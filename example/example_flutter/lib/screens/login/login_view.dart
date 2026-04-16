import 'package:example_client/example_client.dart' show Client;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, Client? client}) : _client = client;

  final Client? _client;

  Client get client => _client ?? GetIt.I<Client>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SignInWidget(
          client: client,
          disableAnonymousSignInWidget: true,
        ),
      ),
    );
  }
}
