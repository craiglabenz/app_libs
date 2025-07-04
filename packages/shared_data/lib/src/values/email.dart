import 'package:email_validator/email_validator.dart';
import 'package:shared_data/shared_data.dart';

/// Validation and wrapper around a raw email address string value.
class Email {
  /// Generative constructor.
  Email(String raw) : _raw = raw;

  final String _raw;
  var _hasValidated = false;

  /// Guarantees this raw email passes all checks. Call this before saving
  /// to the database.
  InvalidValueError? validate() {
    if (!EmailValidator.validate(_raw)) {
      return const InvalidEmail();
    }
    _hasValidated = true;
    return null;
  }

  /// Static value for testing.
  static final test = Email('some@email.com');

  /// Access raw email value. Must call `validate()` before accessing this.
  String get value {
    if (!_hasValidated) {
      throw Exception('Must validate before accessing raw value');
    }
    return _raw;
  }
}
