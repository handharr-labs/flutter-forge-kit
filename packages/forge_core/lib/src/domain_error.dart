/// A layer-agnostic error surfaced through [Result] instead of being thrown.
///
/// Data-layer failures (network, parsing, storage) are mapped to one of these
/// at the Repository boundary so the Domain and Presentation layers never see
/// transport-specific exception types.
sealed class DomainError {
  const DomainError(this.message, {this.cause});

  /// Human-readable, non-localized description for logs.
  final String message;

  /// The originating error, if any. Never assume a concrete type.
  final Object? cause;

  @override
  String toString() => '$runtimeType($message)';
}

/// No connectivity, timeout, or transport-level failure.
final class NetworkError extends DomainError {
  const NetworkError(super.message, {super.cause});
}

/// The server responded with a non-success status.
final class ServerError extends DomainError {
  const ServerError(super.message, {this.statusCode, super.cause});
  final int? statusCode;
}

/// A response or stored payload could not be decoded into a model.
final class DecodingError extends DomainError {
  const DecodingError(super.message, {super.cause});
}

/// The requested resource was absent (cache miss under a strict policy, 404…).
final class NotFoundError extends DomainError {
  const NotFoundError(super.message, {super.cause});
}

/// Authentication/authorization failed.
final class UnauthorizedError extends DomainError {
  const UnauthorizedError(super.message, {super.cause});
}

/// Anything not captured by a more specific case.
final class UnknownError extends DomainError {
  const UnknownError(super.message, {super.cause});
}
