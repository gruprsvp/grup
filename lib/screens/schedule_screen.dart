import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/presentation/presentation.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createNewEvent),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: ScheduleForm(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(l10n.save),
        icon: const Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
