import 'logger.dart';

/// A typed analytics event. Subclass per domain event rather than passing loose
/// strings, so the event surface is discoverable and refactor-safe.
class AnalyticsEvent {
  const AnalyticsEvent(this.name, {this.parameters = const {}});
  final String name;
  final Map<String, Object?> parameters;

  @override
  String toString() => 'AnalyticsEvent($name, $parameters)';
}

/// The seam between the app and whatever analytics backend it uses. Domain code
/// depends on this protocol; the concrete gateway is wired at the composition
/// root (DI container).
abstract interface class AnalyticsGateway {
  void track(AnalyticsEvent event);
}

/// Discards every event. Safe default for tests and previews.
class NoOpAnalyticsGateway implements AnalyticsGateway {
  const NoOpAnalyticsGateway();

  @override
  void track(AnalyticsEvent event) {}
}

/// Logs events through a [Logger]. Handy in development before a real backend
/// is wired up.
class ConsoleAnalyticsGateway implements AnalyticsGateway {
  const ConsoleAnalyticsGateway([this._logger = const ConsoleLogger()]);
  final Logger _logger;

  @override
  void track(AnalyticsEvent event) =>
      _logger.log(LogLevel.info, '📊 ${event.name} ${event.parameters}');
}
