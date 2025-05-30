import 'package:client_app/app/data.dart';
import 'package:client_app/auth/auth.dart';
import 'package:client_auth/client_auth.dart';
import 'package:common/common.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_data/shared_data.dart';

void setUpDI({
  required String apiBaseUrl,
  required FirebaseAuthService firebaseAuthService,
  RequestDelegate requestDelegate = const RequestDelegate.live(),
}) {
  // Base networking services
  GetIt.I.registerSingleton<RequestDelegate>(requestDelegate);
  GetIt.I.registerSingleton<RestApi>(
    RestApi(
      apiBaseUrl: apiBaseUrl,
      headersBuilder: () => {},
    ),
  );

  // Base auth services
  GetIt.I.registerSingleton<FirebaseAuthService>(firebaseAuthService);
  GetIt.I.registerSingleton<RestAuth<User>>(
    RestAuth<User>(
      api: GetIt.I<RestApi>(),
      requestBuilder: const UserRequestBuilder(),
      userBuilder: User.fromJson,
    ),
  );
  GetIt.I.registerSingleton<AuthenticationRepository<User>>(
    AuthenticationRepository<User>(
      streamAuthService: GetIt.I<FirebaseAuthService>(),
      restAuthService: GetIt.I<RestAuth<User>>(),
    ),
  );
  GetIt.I.registerLazySingleton<IncrementRepository>(IncrementRepository.new);
}
