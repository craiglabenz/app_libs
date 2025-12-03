import 'package:data_layer/data_layer.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('AuthUserRepository');

/// {@template AuthUserRepository}
/// Slimmed down [Repository] for the app to update the active [AuthUser]. This
/// should not be confused with the AuthRepository, which is how apps log in and
/// out users.
/// {@endtemplate}
class AuthUserRepository {
  /// {@macro AuthUserRepository}
  AuthUserRepository(SourceList<AuthUser> sourceList, this.bindings)
      : _repo = Repository<AuthUser>(sourceList);

  /// Hidden inner [Repository] to make actual data access calls. Concealed so
  /// as to concretely only expose the desired method -- update the
  /// user.
  final Repository<AuthUser> _repo;

  /// Meta information supplied by the app for server information for how to
  /// update the active [AuthUser].
  Bindings<AuthUser> bindings;

  /// Sends an updated [AuthUser] definition to the server.
  Future<AuthUser?> update(AuthUser user) => _repo.setItem(user);

  /// Loads the active session's [AuthUser] record from the server.
  Future<AuthUser?> refreshUser(String authUserId) async {
    assert(
      _repo.sourceList.sources.last.sourceType == SourceType.remote,
      'Cannot call refreshUser on AuthUserRepository without a remote source '
      'in trailing position. Found ${_repo.sourceList.sources.last}',
    );

    try {
      final readResult = await _repo.sourceList.sources.last.getById(
        authUserId,
        RequestDetails.read(requestType: RequestType.refresh),
      );

      switch (readResult) {
        case ReadSuccess<AuthUser>(:final item):
          return item;
        case ReadFailure<AuthUser>(:final reason, :final message):
          _log.severe(
            'Failed to load AuthUser with Id '
            '$authUserId :: $reason :: $message',
          );
          return null;
      }
    } on Exception catch (e) {
      _log.severe('Failed to load AuthUser with Id $authUserId :: $e');
      return null;
    }
  }
}
