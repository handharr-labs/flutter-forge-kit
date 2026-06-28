import 'package:forge_client/forge_client.dart';
import 'package:forge_core/forge_core.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryLocalDataSource', () {
    test('read of a missing key is NotFoundError', () async {
      final ds = InMemoryLocalDataSource();
      final r = await ds.read('absent');
      expect(r.errorOrNull, isA<NotFoundError>());
    });

    test('write then read returns the stored value', () async {
      final ds = InMemoryLocalDataSource();
      await ds.write('token', 'abc');
      expect((await ds.read('token')).valueOrNull, 'abc');
    });

    test('remove clears the value', () async {
      final ds = InMemoryLocalDataSource();
      await ds.write('k', 'v');
      await ds.remove('k');
      expect((await ds.read('k')).isErr, isTrue);
    });
  });
}
