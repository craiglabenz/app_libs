import 'package:client_app/app/app.dart';
import 'package:client_app/l10n/l10n.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 159, 129, 7),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<IncrementBloc>(create: (context) => IncrementBloc()),
        ],
        child: const IncrementScreen(),
      ),
    );
  }
}

class IncrementScreen extends StatelessWidget {
  const IncrementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncrementBloc, IncrementState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(state.sum.toString())),
          body: SafeArea(
            child: Column(
              children: state.log.map<Widget>(IncrementCard.new).toList(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.read<IncrementBloc>().add(
                  IncrementEvent(
                    IncrementCreate(delta: 1, createdAt: DateTime.now()),
                  ),
                ),
          ),
        );
      },
    );
  }
}

class IncrementCard extends StatelessWidget {
  IncrementCard(this.increment)
      : super(key: Key('increment-card-${increment.id}'));

  final Increment increment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(
          increment.delta.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(increment.createdAt.toIso8601String()),
      ),
    );
  }
}
