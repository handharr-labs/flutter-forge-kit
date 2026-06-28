import 'package:dio/dio.dart';
import 'package:forge_core/forge_core.dart';

/// A thin HTTP seam over Dio that returns [Result] instead of throwing.
///
/// The Data layer builds `*ApiRequest` structs and calls this; Dio exceptions
/// are mapped to [DomainError] here so nothing transport-specific escapes.
abstract interface class ApiClient {
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(Object? json)? decode,
  });

  Future<Result<T>> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    T Function(Object? json)? decode,
  });
}

/// Default [ApiClient] backed by a configured [Dio] instance.
class DioApiClient implements ApiClient {
  DioApiClient(this._dio);
  final Dio _dio;

  /// Convenience constructor for a base URL with sensible timeouts.
  factory DioApiClient.baseUrl(String baseUrl) => DioApiClient(
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ),
      );

  @override
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    T Function(Object? json)? decode,
  }) =>
      _send(() => _dio.get<Object?>(path, queryParameters: query), decode);

  @override
  Future<Result<T>> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    T Function(Object? json)? decode,
  }) =>
      _send(
        () => _dio.post<Object?>(path, data: body, queryParameters: query),
        decode,
      );

  Future<Result<T>> _send<T>(
    Future<Response<Object?>> Function() call,
    T Function(Object? json)? decode,
  ) async {
    try {
      final response = await call();
      final data = response.data;
      try {
        final value = decode != null ? decode(data) : data as T;
        return Ok(value);
      } catch (e) {
        return Err(DecodingError('Failed to decode ${T.toString()}', cause: e));
      }
    } on DioException catch (e) {
      return Err(_mapDioError(e));
    } catch (e) {
      return Err(UnknownError('Unexpected request failure', cause: e));
    }
  }

  DomainError _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401 || status == 403) {
      return UnauthorizedError('Unauthorized ($status)', cause: e);
    }
    if (status == 404) {
      return NotFoundError('Not found', cause: e);
    }
    if (status != null && status >= 400) {
      return ServerError('Server error', statusCode: status, cause: e);
    }
    return NetworkError(e.message ?? 'Network failure', cause: e);
  }
}
