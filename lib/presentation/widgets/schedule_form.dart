import 'package:material_ui/material_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:rrule/rrule.dart';

import 'cutoff_picker.dart';
import 'form_builder_recurrence_rule.dart';
import 'recurrence_label.dart';

class ScheduleForm extends StatefulWidget {
  final Schedule? schedule;
  final ValueChanged<Schedule>? onChanged;

  /// Whether to offer an answer deadline (the group's plan has cutoffs).
  final bool showCutoff;

  const ScheduleForm({
    super.key,
    this.schedule,
    this.onChanged,
    this.showCutoff = false,
  });

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late int? _cutoff = widget.schedule?.cutoffMinutesBefore;

  void _changed() {
    if (_formKey.currentState?.validate(focusOnInvalid: false) ?? false) {
      final displayName =
          _formKey.currentState?.fields['displayName']?.value as String;
      final startDate =
          _formKey.currentState?.fields['startDate']?.value as DateTime;
      final recurrenceRule =
          _formKey.currentState?.fields['recurrenceRule']?.value
              as RecurrenceRule;

      widget.onChanged?.call(
        Schedule(
          id: '',
          groupId: '',
          displayName: displayName,
          startDate: startDate,
          recurrenceRule: recurrenceRule,
          cutoffMinutesBefore: widget.showCutoff ? _cutoff : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FormBuilder(
      key: _formKey,
      onChanged: _changed,
      child: Column(
        spacing: 16,
        children: [
          FormBuilderTextField(
            name: 'displayName',
            autocorrect: true,
            initialValue: widget.schedule?.displayName,
            validator: FormBuilderValidators.required(),
            decoration: InputDecoration(labelText: l10n.eventName),
          ),
          FormBuilderDateTimePicker(
            name: 'startDate',
            inputType: InputType.both,
            initialValue: widget.schedule?.startDate,
            decoration: InputDecoration(labelText: l10n.eventDatetime),
            validator: FormBuilderValidators.required(),
            format: DateFormat.yMMMMEEEEd(
              Localizations.localeOf(context).toString(),
            ).add_Hm(),
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(9999),
          ),
          FormBuilderRecurrenceRule(
            name: 'recurrenceRule',
            initialValue: widget.schedule?.recurrenceRule,
            decoration: InputDecoration(labelText: l10n.recurrenceRule),
            validator: FormBuilderValidators.required(),
            label: (rule) => recurrenceLabel(l10n, rule),
          ),
          if (widget.showCutoff)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_clock_outlined),
              title: Text(l10n.cutoffLabel),
              subtitle: Text(cutoffLabel(l10n, _cutoff)),
              onTap: () async {
                final picked = await pickCutoff(context, current: _cutoff);
                if (picked == null) return;
                setState(() => _cutoff = picked.minutes);
                _changed();
              },
            ),
        ],
      ),
    );
  }
}
