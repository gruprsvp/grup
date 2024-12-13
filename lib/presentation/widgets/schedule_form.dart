import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:rrule/rrule.dart';

import 'form_builder_recurrence_rule.dart';

class ScheduleForm extends StatefulWidget {
  final Schedule? schedule;
  final Function(Schedule)? onChanged;

  const ScheduleForm({
    super.key,
    this.schedule,
    this.onChanged,
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
      onChanged: () {
        if (_formKey.currentState?.validate(focusOnInvalid: false) ?? false) {
          final displayName =
              _formKey.currentState?.fields['displayName']?.value as String;
          final startDate =
              _formKey.currentState?.fields['startDate']?.value as DateTime;
          final recurrenceRule = _formKey
              .currentState?.fields['recurrenceRule']?.value as RecurrenceRule;

          widget.onChanged?.call(Schedule(
            id: '',
            groupId: '',
            displayName: displayName,
            startDate: startDate,
            recurrenceRule: recurrenceRule,
          ));
        }
      },
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'displayName',
            autocorrect: true,
            initialValue: widget.schedule?.displayName,
            validator: FormBuilderValidators.required(),
            decoration: InputDecoration(
              labelText: l10n.eventName,
            ),
          ),
          FormBuilderDateTimePicker(
            name: 'startDate',
            inputType: InputType.both,
            initialValue: widget.schedule?.startDate,
            decoration: InputDecoration(
              labelText: l10n.eventDatetime,
            ),
            validator: FormBuilderValidators.required(),
            format: DateFormat.yMMMMEEEEd().add_Hm(),
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(9999),
          ),
          // TODO: Move this outside
          FutureBuilder(
            future: RruleL10nEn.create(),
            builder: (context, snapshot) => snapshot.hasData
                ? FormBuilderRecurrenceRule(
                    name: 'recurrenceRule',
                    initialValue: widget.schedule?.recurrenceRule,
                    decoration: InputDecoration(
                      labelText: l10n.recurrenceRule,
                    ),
                    validator: FormBuilderValidators.required(),
                    rruleL10n: snapshot.data as RruleL10n,
                  )
                : const CircularProgressIndicator.adaptive(),
          ),
        ],
      ),
    );
  }
}
