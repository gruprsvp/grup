import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class ScheduleCreateScreen extends StatefulWidget {
  const ScheduleCreateScreen({super.key});

  @override
  createState() => _ScheduleCreateScreenState();
}

class _ScheduleCreateScreenState extends State<ScheduleCreateScreen> {
  bool _showSaveButton = false;
  Schedule? _schedule;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createNewEvent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScheduleForm(
          onChanged: (schedule) {
            setState(() {
              _showSaveButton = true;
            });
            _schedule = schedule;
          },
        ),
      ),
      floatingActionButton: _showSaveButton
          ? FloatingActionButton.extended(
              onPressed: () => context.pop(_schedule),
              label: Text(l10n.save),
              icon: const Icon(Icons.check),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
