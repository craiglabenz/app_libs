import 'package:shared_data/shared_data.dart';
import 'package:test/test.dart';

void main() {
  group('ApiKey should', () {
    test('report invalid', () {
      expect(ApiKey('asdf').validate(), equals(const InvalidApiKey()));
    });
    test('allow valid', () {
      expect(ApiKey('12345678901234567890123456789012').validate(), isNull);
      expect(ApiKey.test.validate(), isNull);
      expect(ApiKey.generate().validate(), isNull);
    });
  });
}
