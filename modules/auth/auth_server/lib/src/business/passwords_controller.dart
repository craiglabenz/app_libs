import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:serverpod/serverpod.dart';

/// The default generate password hash, using argon2id.
///
/// Warning: Using a custom hashing algorithm for passwords
/// will permanently disrupt compatibility with Serverpod's
/// password hash validation and migration.
Future<String> generatePasswordHash(String password) => PasswordHash.argon2id(
  password,
  pepper: EmailSecrets.pepper,
  allowUnsecureRandom: false,
);

/// The default validation password hash.
///
/// Warning: Using a custom hashing algorithm for passwords
/// will permanently disrupt compatibility with Serverpod's
/// password hash validation and migration.
Future<bool> validatePasswordHash(
  String password,
  String email,
  String hash, {
  void Function({required String passwordHash, required String storedHash})?
  onValidationFailure,
  void Function(Object e)? onError,
}) async {
  try {
    return await PasswordHash(
      hash,
      legacySalt: EmailSecrets.legacySalt,
      pepper: EmailSecrets.pepper,
    ).validate(password, onValidationFailure: onValidationFailure);
  } catch (e) {
    onError?.call(e);
    return false;
  }
}

/// A class for handling password hashes.
class PasswordHash {
  // Recommended salt length by ietf.
  // https://www.ietf.org/archive/id/draft-ietf-kitten-password-storage-04.html#name-storage-2
  static const int _saltLength = 16;

  late final _PasswordHashGenerator _hashGenerator;
  late final String _hash;

  /// Creates a new [PasswordHash] from a password hash string used to validate
  /// passwords using the same hashing algorithm.
  ///
  /// Throws an [ArgumentError] if the password hash is not recognized.
  PasswordHash(
    String passwordHash, {
    required String legacySalt,
    String? pepper,
  }) {
    var passwordHashParts = passwordHash.split('\$');
    var [_, _, salt, hash] = passwordHashParts;
    _hash = hash;
    _hashGenerator = _Argon2idPasswordHashGenerator(salt: salt, pepper: pepper);
  }

  /// Checks if a password matches the hash.
  ///
  /// If the password does not match the hash, the [onValidationFailure] function
  /// will be called with the hash and the password hash as arguments.
  Future<bool> validate(
    String password, {
    void Function({required String storedHash, required String passwordHash})?
    onValidationFailure,
  }) async {
    var passwordHash = await Isolate.run(
      () => _hashGenerator.generateHash(password),
    );

    if (_hash != passwordHash) {
      onValidationFailure?.call(storedHash: _hash, passwordHash: passwordHash);
      return false;
    }

    return true;
  }

  /// Creates a new password hash using the Argon2id algorithm.
  ///
  /// The [salt] parameter should only be used in testing and development.
  /// If omitted a random salt will be generated which is the recommended way
  /// to use this function in production.
  ///
  /// The [allowUnsecureRandom] parameter can be used to allow unsecure random
  /// number generation. If set to false (default value), an error will be thrown
  /// if the platform does not support secure random number generation.
  static Future<String> argon2id(
    String password, {
    String? salt,
    String? pepper,
    bool allowUnsecureRandom = false,
  }) async => Isolate.run(() {
    var encodedSalt = _generateSalt(
      salt: salt,
      allowUnsecureRandom: allowUnsecureRandom,
    );

    return _Argon2idPasswordHashGenerator(
      salt: encodedSalt,
      pepper: pepper,
    ).generatePasswordHash(password);
  });

  static String _generateSalt({
    required bool allowUnsecureRandom,
    String? salt,
  }) {
    if (salt != null) {
      return const Base64Encoder().convert(salt.codeUnits);
    }

    try {
      return Random.secure().nextString(length: _saltLength);
    } on UnsupportedError {
      if (!allowUnsecureRandom) {
        rethrow;
      }
    }

    return Random().nextString(length: _saltLength);
  }
}

/// Interface for password hash generators.
abstract interface class _PasswordHashGenerator {
  /// Generates a hash from a password.
  String generateHash(String password);
}

/// A password hash generator for Argon2id password hashes.
class _Argon2idPasswordHashGenerator implements _PasswordHashGenerator {
  final String _salt;
  final String? _pepper;

  _Argon2idPasswordHashGenerator({required String salt, String? pepper})
    : _salt = salt,
      _pepper = pepper;

  String generatePasswordHash(String password) {
    var hash = generateHash(password);
    return '\$argon2id\$$_salt\$$hash';
  }

  @override
  String generateHash(String password) {
    var parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_id,
      // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
      // ignore: unnecessary_cast
      utf8.encode(_salt) as Uint8List,
      desiredKeyLength: 256,
      // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
      // ignore: unnecessary_cast
      secret: _pepper != null ? utf8.encode(_pepper) as Uint8List : null,
    );

    var generator = Argon2BytesGenerator()..init(parameters);
    // Required cast because of a breaking change in dart 3.2: https://github.com/dart-lang/sdk/issues/52801
    // ignore: unnecessary_cast
    var hashBytes = generator.process(utf8.encode(password) as Uint8List);

    return const Base64Encoder().convert(hashBytes);
  }
}

/// An extension for generating random strings.
extension RandomString on Random {
  /// Returns a random [String] consisting of letters and numbers, by default
  /// the [length] of the string will be 16 characters.
  String nextString({
    int length = 16,
    String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890',
  }) {
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(nextInt(chars.length))),
    );
  }
}

/// Secrets used for email authentication.
abstract class EmailSecrets {
  /// The salt used for hashing legacy passwords.
  static String get legacySalt =>
      Serverpod.instance.getPassword('email_password_salt') ??
      'serverpod password salt';

  /// The pepper used for hashing passwords.
  static String? get pepper =>
      Serverpod.instance.getPassword('emailPasswordPepper');
}
