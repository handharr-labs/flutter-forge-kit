enum LogLevel { debug, info, warning, error }

/// A minimal logging seam so packages never call `print` directly. The app
/// supplies a concrete implementation at the composition root.
abstract interface class Logger {
  void log(LogLevel level, Object? message, {Object? error, StackTrace? stack});
}

/// Writes to stdout. Replace with a structured logger in production apps.
class ConsoleLogger implements Logger {
  const ConsoleLogger();

  @override
  void log(
    LogLevel level,
    Object? message, {
    Object? error,
    StackTrace? stack,
  }) {
    // ignore: avoid_print — intentional console sink for the default logger.
    print('[${level.name.toUpperCase()}] $message'
        '${error != null ? ' | $error' : ''}');
  }
}

/// Discards everything. Default for tests.
class NoOpLogger implements Logger {
  const NoOpLogger();

  @override
  void log(LogLevel level, Object? message, {Object? error, StackTrace? stack}) {}
}
