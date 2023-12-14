import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:rrule/rrule.dart';

import 'recurrence_rule_picker.dart';

class ScheduleForm extends StatefulWidget {
  final Schedule? schedule;

  const ScheduleForm({
    super.key,
    this.schedule,
  });

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FormBuilder(
      key: _formKey,
      onChanged: () {},
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'name',
            autocorrect: true,
            decoration: InputDecoration(
              labelText: l10n.eventName,
            ),
          ),
          FormBuilderDateTimePicker(
            name: 'datetime',
            inputType: InputType.both,
            decoration: InputDecoration(
              labelText: l10n.eventDatetime,
            ),
            initialTime: TimeOfDay(hour: 8, minute: 0),
            format: DateFormat.yMMMMEEEEd().add_Hm(),
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          ),
          // TODO: Move this outside
          FutureBuilder(
            future: RruleL10nEn.create(),
            builder: (context, snapshot) => snapshot.hasData
                ? RecurrenceRulePicker(
                    name: 'recurrenceRule',
                    decoration: InputDecoration(
                      labelText: l10n.recurrenceRule,
                      suffixIcon: const Icon(Icons.event_repeat),
                    ),
                    rruleL10n: snapshot.data as RruleL10n,
                  )
                : const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
