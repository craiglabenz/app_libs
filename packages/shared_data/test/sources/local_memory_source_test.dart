import 'package:shared_data/shared_data.dart';
import 'package:test/test.dart';
import '../models/test_model.dart';

final details = RequestDetails<TestModel>();
final abcDetails = RequestDetails<TestModel>(
  filters: const [MsgStartsWithFilter('abc')],
);
final abcDetailsNoOverwrite = RequestDetails<TestModel>(
  filters: const [MsgStartsWithFilter('abc')],
  shouldOverwrite: false,
);

void main() {
  late LocalMemorySource<TestModel> mem;

  group('LocalMemorySource.setItem should', () {
    late LocalMemorySource<TestModel> idSettingMem;
    setUp(() {
      mem = LocalMemorySource<TestModel>(bindings: TestModel.bindings);
      idSettingMem = LocalMemorySource<TestModel>(
        bindings: TestModel.bindings,
        canSetIds: true,
      );
    });

    test('save items', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, details);
      fullyContains(mem, item);

      const item2 = TestModel(id: 'item 2');
      mem.setItem(item2, abcDetails);
      fullyContains(mem, item2, cacheKeys: [abcDetails.cacheKey]);
    });

    test('accept items twice', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, details);
      fullyContains(mem, item);

      mem.setItem(item, details);
      fullyContains(mem, item);

      expect(mem.itemIds.length, equals(1));
    });

    test('overwrite', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, details);
      fullyContains(mem, item);

      const itemTake2 = TestModel(id: 'item 1', msg: 'different');
      mem.setItem(itemTake2, details);
      fullyContains(mem, itemTake2);
      expect(mem.itemIds.length, equals(1));
    });

    test('honor overwrite=False', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, details);
      fullyContains(mem, item);

      const itemTake2 = TestModel(id: 'item 1', msg: 'different');
      mem.setItem(itemTake2, RequestDetails(shouldOverwrite: false));
      fullyContains(mem, item);
      expect(mem.itemIds.length, equals(1));
    });

    test('cache pagination info', () {
      final deets = RequestDetails<TestModel>(
        pagination: Pagination.page(2),
      );
      final item = TestModel.randomId();
      mem.setItem(item, deets);
      expect(mem.requestCache, contains(deets.cacheKey));
      expect(mem.requestCache[deets.cacheKey], contains(item.id));
      expect(mem.requestCache[deets.empty.cacheKey], contains(item.id));
    });

    test('set Ids', () async {
      const item = TestModel(id: null, msg: 'hello');
      final result = await idSettingMem.setItem(item, details);
      expect(result, isA<WriteSuccess>());
      expect((result as WriteSuccess).item.id, isNotNull);
    });
  });

  group('LocalMemorySource.setItems should', () {
    setUp(() {
      mem = LocalMemorySource<TestModel>(bindings: TestModel.bindings);
    });

    test('set items', () {
      const item = TestModel(id: 'item 1');
      const item2 = TestModel(id: 'item 2');
      mem.setItems([item, item2], details);
      fullyContains(mem, item);
      fullyContains(mem, item2);

      const item3 = TestModel(id: 'item 3');
      mem.setItems([item2, item3], details);
      fullyContains(mem, item);
      fullyContains(mem, item2);
      fullyContains(mem, item3);
      expect(mem.itemIds.length, 3);
    });

    test('set items with set name', () {
      const item = TestModel(id: 'item 1');
      const item2 = TestModel(id: 'item 2');
      mem.setItems([item, item2], details);
      fullyContains(mem, item);
      fullyContains(mem, item2);

      const item3 = TestModel(id: 'item 3');
      mem.setItems([item2, item3], abcDetails);
      fullyContains(mem, item);
      fullyContains(mem, item2, cacheKeys: [abcDetails.cacheKey]);
      fullyContains(mem, item3, cacheKeys: [abcDetails.cacheKey]);
      expect(mem.itemIds.length, 3);
    });
  });

  group('LocalMemorySource.getById should', () {
    setUp(() {
      mem = LocalMemorySource<TestModel>(bindings: TestModel.bindings);
    });

    test('return known items', () async {
      const item = TestModel(id: 'item 1');
      await mem.setItem(item, details);
      final maybeResult = await mem.getById(item.id!, details);
      expect(maybeResult, isA<ReadSuccess>());
      expect((maybeResult as ReadSuccess).item, equals(item));
    });

    test('return empty ReadSuccess for unknown items', () async {
      const item = TestModel(id: 'item 1');
      await mem.setItem(item, details);

      const item2 = TestModel(id: 'item 2');

      final retrievedItem = await mem.getById(item2.id!, details);
      expect(retrievedItem, isA<ReadSuccess>());
      expect((retrievedItem as ReadSuccess).item, isNull);
    });

    test('honor setName', () async {
      const item = TestModel(id: 'item 1');
      await mem.setItem(item, details);
      final retrievedItem = await mem.getById(item.id!, abcDetails);
      expect(retrievedItem, isA<ReadSuccess>());
      expect((retrievedItem as ReadSuccess).item, isNull);

      await mem.setItem(item, abcDetails);
      final retrievedItem2 = await mem.getById(item.id!, abcDetails);
      expect(retrievedItem2, isA<ReadSuccess>());
      expect((retrievedItem2 as ReadSuccess).item, item);
    });

    test('honor pagination', () async {
      final deets = RequestDetails<TestModel>();
      final page1Deets = RequestDetails<TestModel>(
        pagination: Pagination.page(1),
      );
      final page2Deets = RequestDetails<TestModel>(
        pagination: Pagination.page(2),
      );
      final item = TestModel.randomId();
      await mem.setItem(item, page1Deets);

      final result = await mem.getById(item.id!, deets);
      expect(result, isA<ReadSuccess>());
      expect((result as ReadSuccess).item, isNotNull);

      final page1Result = await mem.getById(item.id!, page1Deets);
      expect(page1Result, isA<ReadSuccess>());
      expect((page1Result as ReadSuccess).item, isNotNull);

      final page2Result = await mem.getById(item.id!, page2Deets);
      expect(page2Result, isA<ReadSuccess>());
      expect((page2Result as ReadSuccess).item, isNull);
    });
  });

  group('LocalMemorySource.getByIds should', () {
    const item = TestModel(id: 'item 1');
    const item2 = TestModel(id: 'item 2');
    setUp(() {
      mem = LocalMemorySource<TestModel>(bindings: TestModel.bindings);
    });

    test('return items', () async {
      await mem.setItems([item, item2], details);
      final maybeResult = await mem.getByIds(
        {item.id!, item2.id!},
        details,
      );
      expect(maybeResult, isA<ReadListSuccess>());
      final result = maybeResult as ReadListSuccess<TestModel>;
      expect(
        result,
        ReadListResult<TestModel>.fromList([item, item2], details, {}),
      );
    });

    test('return items for partial hits', () async {
      const item3 = TestModel(id: 'item 3');
      await mem.setItems([item, item2], details);
      final maybeResult = await mem.getByIds(
        {item.id!, item2.id!, item3.id!},
        details,
      );
      expect(maybeResult, isA<ReadListSuccess>());
      final result = maybeResult as ReadListSuccess<TestModel>;
      expect(
        result,
        ReadListResult<TestModel>.fromList(
          [item, item2],
          details,
          {item3.id!},
        ),
      );
    });
  });

  group('LocalMemorySource.getItems should', () {
    const item = TestModel(id: 'item 1');
    const item2 = TestModel(id: 'item 2');
    setUp(() {
      mem = LocalMemorySource<TestModel>(bindings: TestModel.bindings);
    });
    test('return items', () async {
      await mem.setItems([item, item2], details);
      final maybeResult = await mem.getItems(details);
      expect(
        maybeResult,
        ReadListResult<TestModel>.fromList([item, item2], details, {}),
      );
    });

    test('return no items from setName if empty', () async {
      await mem.setItems([item, item2], abcDetails);

      final xyzDetails = RequestDetails<TestModel>(
        filters: const [MsgStartsWithFilter('xyz')],
      );
      final maybeResult = await mem.getItems(xyzDetails);
      expect(maybeResult, isA<ReadListSuccess>());
      final result = maybeResult as ReadListSuccess;
      expect(result.items, isEmpty);
      expect(result.itemsMap, isEmpty);
      expect(result.missingItemIds, isEmpty);
      expect(result.details.pagination, isNull);
      expect(result.details, xyzDetails);

      final maybeResult2 = await mem.getItems(details);
      final result2 = maybeResult2 as ReadListSuccess;
      expect(
        result2,
        ReadListResult<TestModel>.fromList([item, item2], details, {}),
      );
    });

    test('return no items from custom setName if empty', () async {
      await mem.setItems([item, item2], details);
      final maybeResult = await mem.getItems(abcDetails);
      expect(maybeResult, isA<ReadListSuccess>());
      final result = maybeResult as ReadListSuccess<TestModel>;
      expect(
        result,
        ReadListResult<TestModel>.fromList(
          [],
          abcDetails,
          {},
        ),
      );
    });

    test('honor filters', () async {
      const item3 = TestModel(id: 'item 3', msg: 'holy moly');
      await mem.setItems([item, item2, item3], details);
      final holyDetails = RequestDetails<TestModel>(
        filters: const [MsgStartsWithFilter('holy')],
      );
      final maybeResult = await mem.getItems(holyDetails);
      final result = maybeResult as ReadListSuccess;
      expect(
        result,
        ReadListResult<TestModel>.fromList([item3], holyDetails, {}),
      );
    });

    test('return items', () async {
      await mem.setItems([item, item2], details);
      final maybeResult = await mem.getItems(details);
      final result = maybeResult as ReadListSuccess;
      expect(
        result,
        ReadListResult<TestModel>.fromList([item, item2], details, {}),
      );
    });

    test('return items that satisfy a previously unseen request', () async {
      const asdf = TestModel(id: 'item 1', msg: 'asdf');
      const xyz = TestModel(id: 'item 2', msg: 'xyz');

      await mem.setItems([asdf, xyz], details);
      final deets = RequestDetails<TestModel>(
        filters: const [MsgStartsWithFilter('asdf')],
      );
      final maybeResult = await mem.getItems(deets);
      final result = maybeResult as ReadListSuccess<TestModel>;
      expect(result.items, hasLength(1));
      expect(result.items.first.msg, 'asdf');
    });

    test('honor pagination', () async {
      final deets = RequestDetails<TestModel>();
      final page1Deets = RequestDetails<TestModel>(
        pagination: Pagination.page(1),
      );
      final page2Deets = RequestDetails<TestModel>(
        pagination: Pagination.page(2),
      );

      final item = TestModel.randomId();
      final item2 = TestModel.randomId();
      await mem.setItems([item, item2], page2Deets);

      final deetsResults = await mem.getItems(deets);
      expect((deetsResults as ReadListSuccess).items, hasLength(2));
      final page1DeetsResults = await mem.getItems(page1Deets);
      expect((page1DeetsResults as ReadListSuccess).items, hasLength(0));
      final page2DeetsResults = await mem.getItems(page2Deets);
      expect((page2DeetsResults as ReadListSuccess).items, hasLength(2));
    });
  });

  group('LocalMemorySource.requestCache should', () {
    const item = TestModel(id: 'item 1');
    const item2 = TestModel(id: 'item 2');
    setUp(() {
      mem = LocalMemorySource<TestModel>(bindings: TestModel.bindings);
    });
    test('contain saved objects', () {
      mem.setItems([item, item2], details);
      expect(mem.requestCache, contains(details.cacheKey));
      expect(
        mem.requestCache[details.cacheKey],
        containsAll([item.id, item2.id]),
      );
    });
    test('contain saved objects with filters', () {
      final detailsWithFilter = RequestDetails<TestModel>(
        filters: const [MsgStartsWithFilter('asdf')],
      );
      mem.setItems([item, item2], detailsWithFilter);
      expect(mem.requestCache, contains(details.cacheKey));
      expect(mem.requestCache, contains(detailsWithFilter.cacheKey));
      expect(
        mem.requestCache[details.cacheKey],
        containsAll([item.id, item2.id]),
      );
      expect(
        mem.requestCache[detailsWithFilter.cacheKey],
        containsAll([item.id, item2.id]),
      );
    });

    test('contain saved objects with filters after writing w no filters', () {
      mem.setItems([item, item2], details);
      final detailsWithFilter = RequestDetails<TestModel>(
        filters: const [MsgStartsWithFilter('asdf')],
      );
      mem.setItems([item, item2], detailsWithFilter);
      expect(mem.requestCache, contains(details.cacheKey));
      expect(mem.requestCache, contains(detailsWithFilter.cacheKey));
      expect(
        mem.requestCache[details.cacheKey],
        containsAll([item.id, item2.id]),
      );
      expect(
        mem.requestCache[detailsWithFilter.cacheKey],
        containsAll([item.id, item2.id]),
      );
    });
  });
}

void fullyContains(
  LocalMemorySource<TestModel> mem,
  TestModel item, {
  List<int> cacheKeys = const [],
}) {
  expect(item.id, isNotNull);
  expect(mem.itemIds, contains(item.id));
  expect(mem.items, contains(item.id));
  expect(
    mem.requestCache[RequestDetails<TestModel>().cacheKey],
    contains(item.id),
  );
  for (final int setName in cacheKeys) {
    expect(mem.requestCache, contains(setName));
    expect(mem.requestCache[setName], contains(item.id));
  }
  expect(mem.items[item.id!]!.msg, item.msg);
}
