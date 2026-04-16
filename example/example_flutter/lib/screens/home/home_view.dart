import 'package:example_client/example_client.dart' show Client;
import 'package:example_flutter/core/auth/auth_service.dart' show AuthService;
import 'package:flutter/material.dart';
import 'package:example_flutter/screens/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// {@template HomeScreen}
/// Initial Home screen.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro HomeScreen}
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc bloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: state.session != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => {},
                      child: Text(
                        'Welcome ${state.session!.authUserId}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: () => bloc.add(const HomeEvent.logOut()),
                      child: Text(
                        'Log out',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                )
              : SignInWidget(
                  client: GetIt.I<Client>(),
                  // disableAppleSignInWidget: true,
                  // disableGoogleSignInWidget: true,
                  // disableEmailSignInWidget: true,
                ),
        );
      },
    );
  }

  @override
  Future<void> dispose() async {
    await bloc.close();
    super.dispose();
  }
}
