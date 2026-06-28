/// How a Repository should reconcile cached and remote data for a request.
///
/// Travels on [Request] from the ViewModel/BLoC down to the Repository, so the
/// caller — not the data layer — owns the freshness decision.
enum FetchPolicy {
  /// Always hit the network; ignore any cache.
  fresh,

  /// Return cache if present, otherwise fall back to the network.
  cached,

  /// Cache only. A miss is a [NotFoundError]; the network is never touched.
  strict,
}
