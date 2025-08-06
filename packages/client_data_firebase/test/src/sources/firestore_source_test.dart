// Subtyping for tests.
// ignore_for_file: subtype_of_sealed_class

import 'package:client_data_firebase/client_data_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_data/shared_data.dart';

class FirebaseFirestoreMock extends Mock implements FirebaseFirestore {}

class CollectionReferenceMock<T> extends Mock
    implements CollectionReference<T> {}

class QueryMock<T> extends Mock implements Query<T> {}

class QuerySnapshotMock<T> extends Mock implements QuerySnapshot<T> {}

class QueryDocumentSnapshotMock<T> extends Mock
    implements QueryDocumentSnapshot<T> {}

class DocumentReferenceMock<T> extends Mock implements DocumentReference<T> {}

class DocumentSnapshotMock<T> extends Mock implements DocumentSnapshot<T> {}

/// Used for reads
const homerSimpsonData = {'id': 'abc', 'name': 'Homer Simpson'};
const homerSimpsonCreationData = {'name': 'Homer Simpson'};

const bartSimpsonData = {'id': 'xyz', 'name': 'Bart Simpson'};
const bartSimpsonCreationData = {'name': 'Bart Simpson'};

const homerSimpson = _TestModel(id: 'abc', name: 'Homer Simpson');

const bartSimpson = _TestModel(id: 'xyz', name: 'Bart Simpson');

final details = RequestDetails.read();

void main() {
  final dbMock = FirebaseFirestoreMock();
  final colRefMock = CollectionReferenceMock<Json>();
  final queryMock = QueryMock<Json>();
  final querySnapshotMock = QuerySnapshotMock<Json>();
  final queryDocumentSnapshotMock = QueryDocumentSnapshotMock<Json>();
  final docRefMock = DocumentReferenceMock<Json>();
  final docSnapshotMock = DocumentSnapshotMock<Json>();

  final source = FirestoreSource<_TestModel>(
    db: dbMock,
    bindings: _TestModel.bindings,
  );

  group('FirestoreSource.getById should', () {
    setUp(() {
      reset(dbMock);
      reset(colRefMock);
      reset(docRefMock);
      reset(docSnapshotMock);

      when(() => dbMock.collection(any())).thenReturn(colRefMock);
      when(() => colRefMock.doc(any())).thenReturn(docRefMock);
      when(docRefMock.get).thenAnswer((_) async => docSnapshotMock);
    });

    test('load an object', () async {
      when(docSnapshotMock.data).thenReturn(homerSimpsonCreationData);
      when(() => docSnapshotMock.id).thenReturn('abc');

      final result = await source.getById('abc', details);
      expect(result, isSuccess);
      expect((result as ReadSuccess<_TestModel>).item, homerSimpson);
    });

    test('return success for a missing object', () async {
      when(docSnapshotMock.data).thenReturn(null);

      final result = await source.getById('abc', details);
      expect(result, isSuccess);
      expect((result as ReadSuccess<_TestModel>).item, isNull);
    });
  });

  group('FirestoreSource.getByIds should', () {
    setUp(() {
      reset(dbMock);
      reset(colRefMock);
      reset(queryMock);
      reset(querySnapshotMock);
      reset(queryDocumentSnapshotMock);

      when(() => dbMock.collection(any())).thenReturn(colRefMock);
      when(
        () => colRefMock.where(
          FieldPath.documentId,
          whereIn: any(named: 'whereIn'),
        ),
      ).thenReturn(queryMock);
      when(queryMock.get).thenAnswer((_) async => querySnapshotMock);
    });

    test('load those Ids', () async {
      when(
        () => querySnapshotMock.docs,
      ).thenReturn([queryDocumentSnapshotMock]);
      when(queryDocumentSnapshotMock.data).thenReturn(homerSimpsonData);
      final result = await source.getByIds({'abc'}, details);
      expect(result, isSuccess);
      expect((result as ReadListSuccess<_TestModel>).items, {homerSimpson});
      expect(result.missingItemIds, <String>{});
    });

    test('return missingIds', () async {
      when(
        () => querySnapshotMock.docs,
      ).thenReturn([queryDocumentSnapshotMock]);
      when(queryDocumentSnapshotMock.data).thenReturn(homerSimpsonData);
      final result = await source.getByIds({'abc', 'xyz'}, details);
      expect(result, isSuccess);
      expect((result as ReadListSuccess<_TestModel>).items, {homerSimpson});
      expect(result.missingItemIds, <String>{bartSimpson.id!});
    });

    test('return empty sets', () async {
      when(() => querySnapshotMock.docs).thenReturn([]);
      final result = await source.getByIds({'abc', 'xyz'}, details);
      expect(result, isSuccess);
      expect((result as ReadListSuccess<_TestModel>).items, <_TestModel>{});
      expect(result.missingItemIds, <String>{
        homerSimpson.id!,
        bartSimpson.id!,
      });
    });

    test('applyFilters', () async {
      when(
        () => querySnapshotMock.docs,
      ).thenReturn([queryDocumentSnapshotMock]);
      when(queryDocumentSnapshotMock.data).thenReturn(homerSimpsonData);

      var isFiltered = false;
      Query<Json> filterCallback(Query<Json> q) {
        isFiltered = true;
        return q;
      }

      final filter = _FirestoreFilterMock(filterCallback);
      final filterDetails = RequestDetails.read(filter: filter);

      final result = await source.getByIds({'abc'}, filterDetails);
      expect(result, isSuccess);
      expect((result as ReadListSuccess<_TestModel>).items, {homerSimpson});
      expect(result.missingItemIds, <String>{});
      expect(isFiltered, isTrue);
    });
  });

  group('FirestoreSource.getItems should', () {
    setUp(() {
      reset(dbMock);
      reset(colRefMock);
      reset(queryMock);
      reset(querySnapshotMock);
      reset(queryDocumentSnapshotMock);

      when(() => dbMock.collection(any())).thenReturn(colRefMock);
      when(colRefMock.get).thenAnswer((_) async => querySnapshotMock);
    });

    test('apply filters', () async {
      when(
        () => querySnapshotMock.docs,
      ).thenReturn([queryDocumentSnapshotMock]);
      when(queryDocumentSnapshotMock.data).thenReturn(homerSimpsonData);

      var isFiltered = false;

      Query<Json> filterCallback(Query<Json> q) {
        isFiltered = true;
        return q;
      }

      final filter = _FirestoreFilterMock(filterCallback);
      final filterDetails = RequestDetails.read(filter: filter);

      final result = await source.getItems(filterDetails);
      expect(result, isSuccess);
      expect((result as ReadListSuccess<_TestModel>).items, {homerSimpson});
      expect(result.missingItemIds, <String>{});
      expect(isFiltered, isTrue);
    });
  });

  group('FirestoreSource.setItem should', () {
    setUp(() {
      reset(dbMock);
      reset(colRefMock);

      when(() => dbMock.collection(any())).thenReturn(colRefMock);
      when(() => colRefMock.doc(any())).thenReturn(docRefMock);
    });

    test('save a known item', () async {
      when(
        () => docRefMock.set(bartSimpsonCreationData),
      ).thenAnswer((_) async {});
      final result = await source.setItem(bartSimpson, details);
      expect(result, isA<WriteSuccess<_TestModel>>());
      expect((result as WriteSuccess<_TestModel>).item, equals(bartSimpson));
    });

    test('save a new item', () async {
      when(
        () => colRefMock.add(bartSimpsonCreationData),
      ).thenAnswer((_) async => docRefMock);
      when(docRefMock.get).thenAnswer((_) async => docSnapshotMock);
      when(docSnapshotMock.data).thenReturn(bartSimpsonData);

      final result = await source.setItem(
        // Id is missing
        const _TestModel(name: 'Bart Simpson'),
        details,
      );
      expect(result, isA<WriteSuccess<_TestModel>>());
      expect((result as WriteSuccess<_TestModel>).item, equals(bartSimpson));
    });
  });
}

class _TestModel extends Equatable {
  const _TestModel({required this.name, this.id});

  final String? id;
  final String name;

  Json toJson() => id != null ? {'id': id, 'name': name} : {'name': name};

  static Bindings<_TestModel> get bindings => Bindings<_TestModel>(
    fromJson: (Map<String, Object?> data) =>
        _TestModel(id: data['id'] as String?, name: data['name']! as String),
    getDetailUrl: (String id) => ApiUrl(path: 'tests/$id'),
    getListUrl: () => const ApiUrl(path: 'tests'),
    toJson: (_TestModel obj) => obj.toJson(),
    getId: (_TestModel obj) => obj.id,
  );

  @override
  List<Object?> get props => [id, name];
}

class _FirestoreFilterMock extends Filter with FirestoreFilter {
  const _FirestoreFilterMock(this._filterQuery);

  final Query<Json> Function(Query<Json>) _filterQuery;

  @override
  CacheKey get cacheKey => throw UnimplementedError();

  @override
  Query<Json> filterQuery(Query<Json> query) => _filterQuery(query);

  @override
  Json toJson() => throw UnimplementedError();
}
