import 'result.dart';

/// A single unit of business logic. One public method, [call], so a use case is
/// invoked like a function. Implementations live in the Domain layer and depend
/// only on repository *protocols*, never on concrete Data-layer types.
abstract interface class UseCase<Input, Output> {
  Future<Result<Output>> call(Input input);
}

/// A use case that takes no input.
abstract interface class NoInputUseCase<Output> {
  Future<Result<Output>> call();
}

/// A use case that emits a stream of values (e.g. a live subscription).
abstract interface class StreamUseCase<Input, Output> {
  Stream<Result<Output>> call(Input input);
}
