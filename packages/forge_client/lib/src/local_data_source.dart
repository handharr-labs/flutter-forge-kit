import 'package:forge_core/forge_core.dart';

/// The local-cache seam. The Data layer reads/writes through this; the concrete
/// backend (shared_preferences, hive, sqlite…) is wired at the app's DI root so
/// this package stays Flutter-free.
abstract interface class LocalDataSource {
  Future<Result<String>> read(String key);
  Future<Result<void>> write(String key, String value);
  Future<Result<void>> remove(String key);
}

/// In-memory implementation — the default for tests and previews. A cache miss
/// surfaces as [NotFoundError] so `FetchPolicy.strict` behaves correctly.
class InMemoryLocalDataSource implements LocalDataSource {
  final _store = <String, String>{};

  @override
  Future<Result<String>> read(String key) async {
    final value = _store[key];
    return value == null
        ? Err(NotFoundError('No cached value for "$key"'))
        : Ok(value);
  }

  @override
  Future<Result<void>> write(String key, String value) async {
    _store[key] = value;
    return const Ok(null);
  }

  @override
  Future<Result<void>> remove(String key) async {
    _store.remove(key);
    return const Ok(null);
  }
}
