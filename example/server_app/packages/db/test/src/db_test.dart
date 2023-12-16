// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:db/db.dart';

void main() {
  group('Db', () {
    test('can be instantiated', () {
      expect(Db(), isNotNull);
    });
  });
}
