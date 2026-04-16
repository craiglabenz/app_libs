import 'package:serverpod_auth_idp_server/providers/anonymous.dart';

/// By extending [AnonymousIdpBaseEndpoint], the anonymous identity provider
/// endpoints are made available on the server and enable the corresponding
/// sign-in widget on the client.
class AnonymousIdpEndpoint extends AnonymousIdpBaseEndpoint {}
