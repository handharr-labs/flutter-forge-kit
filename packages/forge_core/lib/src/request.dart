import 'fetch_policy.dart';

/// The unified input to a [UseCase].
///
/// [Q] carries query parameters and [P] carries path/identity parameters.
/// Bundling them with a [FetchPolicy] in one object means adding a field never
/// breaks existing call sites. HTTP-shaped request structs live in the Data
/// layer (`*ApiRequest`) and are built from this — never the reverse.
class Request<Q, P> {
  const Request({
    this.query,
    this.path,
    this.policy = FetchPolicy.cached,
  });

  final Q? query;
  final P? path;
  final FetchPolicy policy;

  Request<Q, P> copyWith({Q? query, P? path, FetchPolicy? policy}) => Request(
        query: query ?? this.query,
        path: path ?? this.path,
        policy: policy ?? this.policy,
      );
}
