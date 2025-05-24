import 'package:shared_data/shared_data.dart';
import 'package:test/test.dart';

import 'test_model.dart';

void main() {
  final sl = FakeSourceList<TestModel>()
    ..addObj(const TestModel(id: 'does not matter'));
  final repo = Repository<TestModel>(sl);
  const TestModel obj = TestModel(id: 'also does not matter');

  group('Repository methods should pass through to SourceList', () {
    final emptyDetails = RequestDetails<TestModel>();
    test('including getById', () async {
      expect(
        await repo.getById('also does not matter', emptyDetails),
        isA<ReadSuccess>(),
      );
    });
    test('including getById', () async {
      expect(
        await repo.getByIds({'also does not matter'}, emptyDetails),
        isA<ReadListSuccess>(),
      );
    });
    test('including getItems', () async {
      expect(
        await repo.getItems(emptyDetails),
        isA<ReadListSuccess>(),
      );
    });
    test('including setItem', () async {
      expect(
        await repo.setItem(obj, emptyDetails),
        isA<WriteSuccess>(),
      );
    });
    test('including setItems', () async {
      expect(
        await repo.setItems([obj], emptyDetails),
        isA<WriteListSuccess>(),
      );
    });
  });
}
