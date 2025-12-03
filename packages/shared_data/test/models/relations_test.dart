import 'package:data_layer/data_layer.dart';
import 'package:shared_data/shared_data.dart';
import 'package:test/test.dart';

class Nested {
  Nested({required this.id, required this.body});

  final String? id;
  final String body;

  static Bindings<Nested> get bindings => Bindings<Nested>(
        getId: (Nested obj) => obj.id,
        toJson: (Nested obj) => Json(), // doesn't matter
        fromJson: (Json data) => Nested(
          id: data['id'] as String?,
          body: data['body']! as String,
        ),
        getDetailUrl: (String id) => ApiUrl(path: 'fake/$id'),
        getListUrl: () => const ApiUrl(path: 'fake'),
      );
}

class WithNestedDetail {
  WithNestedDetail({
    required this.id,
    required this.comment,
  });

  final String? id;
  final RelatedModel<Nested> comment;
}

class WithNestedList {
  WithNestedList({
    required this.id,
    required this.comments,
  });

  final String? id;
  final RelatedModelList<Nested> comments;
}

void main() {
  final nestedSourceList = SourceList(
    sources: [LocalMemorySource<Nested>(bindings: Nested.bindings)],
    bindings: Nested.bindings,
  );

  group('RelatedModel should', () {
    late Repository<Nested> nestedRepository;

    setUpAll(() {
      nestedRepository = Repository<Nested>(nestedSourceList)
        ..setItem(Nested(id: 'abc', body: 'message here'));
    });

    test('seamlessly load obj', () async {
      final obj = WithNestedDetail(
        id: 'xyz',
        comment: RelatedModel<Nested>(id: 'abc', repository: nestedRepository),
      );
      expect((await obj.comment.obj)!.body, 'message here');
    });

    test('return null for unknown id', () async {
      final obj = WithNestedDetail(
        id: 'xyz',
        comment:
            RelatedModel<Nested>(id: 'unknown', repository: nestedRepository),
      );
      expect(await obj.comment.obj, isNull);
    });

    group('RelatedModelList should', () {
      late Repository<Nested> nestedRepository;

      setUpAll(() {
        nestedRepository = Repository<Nested>(nestedSourceList)
          ..setItems(
            [
              Nested(id: 'abc', body: 'message here'),
              Nested(id: 'def', body: 'second message here'),
            ],
            RequestDetails.write(requestType: RequestType.local),
          );
      });

      test('seamlessly load objs', () async {
        final obj = WithNestedList(
          id: 'xyz',
          comments: RelatedModelList<Nested>(
            ids: const {'abc', 'def'},
            repository: nestedRepository,
          ),
        );
        final items = await obj.comments.objs;
        final itemsMap = <String, Nested>{};
        // ignore: avoid_function_literals_in_foreach_calls
        items.forEach((item) => itemsMap[item.id!] = item);
        expect(itemsMap['abc']!.body, 'message here');
        expect(itemsMap['def']!.body, 'second message here');
      });

      test('return empty for unknown id', () async {
        final obj = WithNestedList(
          id: 'xyz',
          comments: RelatedModelList<Nested>(
            ids: const {'unknown'},
            repository: nestedRepository,
          ),
        );
        expect(await obj.comments.objs, isEmpty);
      });
    });
  });
}
