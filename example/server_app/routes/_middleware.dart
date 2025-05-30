import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart';

final _db = Db();

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(provider<Db>((_) => _db));
}
