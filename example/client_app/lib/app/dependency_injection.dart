import 'package:client_app/auth/auth.dart';
import 'package:client_auth/client_auth.dart';
import 'package:common/common.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_data/shared_data.dart';

void setUpDI() {
  // Base networking services
  GetIt.I.registerSingleton<RestApi>(
    RestApi(
      apiBaseUrl: 'http://127.0.0.1',
      headersBuilder: () => <String, String>{},
    ),
  );

  // Base auth services
  GetIt.I.registerSingleton<BaseStreamAuth>(FirebaseAuthService());
  GetIt.I.registerSingleton<BaseRestAuth>(
    RestAuth<User>(
      api: GetIt.I<RestApi>(),
      requestBuilder: const UserRequestBuilder(),
      userBuilder: User.fromJson,
    ),
  );
  GetIt.I.registerSingleton<AuthenticationRepository>(
    AuthenticationRepository(
      streamAuthService: GetIt.I<BaseStreamAuth>(),
      restAuthService: GetIt.I<BaseRestAuth>(),
    ),
  );
}
