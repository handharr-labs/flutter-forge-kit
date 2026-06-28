import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

/// A single multiplexed socket. Callers subscribe to logical [channel]s; the
/// transport stays one connection. Mirrors the iOS kit's actor-based
/// `WebSocketClient` + `ChannelRouter`.
class WebSocketClient {
  WebSocketClient(this._connect);

  /// Injectable connector so tests can supply a fake channel.
  final WebSocketChannel Function(Uri url) _connect;

  factory WebSocketClient.standard() =>
      WebSocketClient((url) => WebSocketChannel.connect(url));

  WebSocketChannel? _channel;
  final _controllers = <String, StreamController<Object?>>{};
  StreamSubscription<Object?>? _sub;

  /// Opens the connection if not already open.
  void connect(Uri url) {
    if (_channel != null) return;
    final channel = _connect(url);
    _channel = channel;
    _sub = channel.stream.listen(
      _route,
      onError: (Object e, StackTrace s) => _broadcastError(e),
      onDone: _closeAll,
    );
  }

  /// A broadcast stream for one logical channel.
  Stream<Object?> channel(String name) => _controllers
      .putIfAbsent(name, () => StreamController<Object?>.broadcast())
      .stream;

  /// Sends a raw frame over the underlying socket.
  void send(Object? message) => _channel?.sink.add(message);

  Future<void> close() async {
    await _sub?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _closeAll();
  }

  // Default routing fans every frame out to all channels; apps override by
  // wrapping this client with their own envelope-aware router.
  void _route(Object? frame) {
    for (final c in _controllers.values) {
      c.add(frame);
    }
  }

  void _broadcastError(Object error) {
    for (final c in _controllers.values) {
      c.addError(error);
    }
  }

  void _closeAll() {
    for (final c in _controllers.values) {
      c.close();
    }
    _controllers.clear();
  }
}
