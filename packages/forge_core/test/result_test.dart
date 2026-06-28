import 'package:forge_core/forge_core.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('Ok carries its value and folds onOk', () {
      const Result<int> r = Ok(42);
      expect(r.isOk, isTrue);
      expect(r.valueOrNull, 42);
      expect(r.fold((v) => 'ok:$v', (e) => 'err'), 'ok:42');
    });

    test('Err carries its error and folds onErr', () {
      const Result<int> r = Err(NetworkError('offline'));
      expect(r.isErr, isTrue);
      expect(r.errorOrNull, isA<NetworkError>());
      expect(r.fold((v) => 'ok', (e) => 'err:${e.message}'), 'err:offline');
    });

    test('map transforms Ok and passes Err through', () {
      expect(const Ok(2).map((v) => v * 10), const Ok(20));
      const err = Err<int>(UnknownError('boom'));
      expect(err.map((v) => v * 10), const Err<int>(UnknownError('boom')));
    });
  });
}
