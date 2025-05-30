import 'package:auth/auth.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart';
import 'package:shared_data/shared_data.dart';

Future<Response> onRequest(RequestContext context) async {
  final db = context.read<Db>();
  final auth = AuthDbSource(db);
  final response = await auth.getItems(RequestDetails<AuthUser>());
  if (response.isRight()) {
    return Response.json(body: response.getOrRaise().items);
  } else {
    return Response(
      body: response.leftOrRaise().toString(),
      statusCode: 400,
    );
  }
}
