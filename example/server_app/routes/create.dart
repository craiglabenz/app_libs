import 'package:auth/auth.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart';
import 'package:shared_data/shared_data.dart' as shared;

Future<Response> onRequest(RequestContext context) async {
  final authUser = shared.AuthUser(
    apiKey: shared.ApiKey.generate().value,
    id: shared.ApiKey.generate().value,
    email: 'another@email.com',
  );

  final db = context.read<Db>();
  final auth = AuthDbSource(db);
  final response = await auth.setItem(
    authUser,
    shared.RequestDetails<shared.AuthUser>(),
  );
  if (response.isRight()) {
    return Response.json(body: response.getOrRaise().item);
  } else {
    return Response(
      body: response.leftOrRaise().toString(),
      statusCode: 400,
    );
  }
}
