import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DateFab extends StatelessWidget {
  final _dateFormat = DateFormat.MMMMEEEEd();
  final DateTime? date;
  final ValueChanged<DateTime>? onDateChanged;

  DateFab({
    super.key,
    this.date,
    this.onDateChanged,
  });

  _selectNewDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -365)),
      lastDate: DateTime(9999),
    );

    if (newDate != null) {
      onDateChanged?.call(newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _selectNewDate(context),
      icon: const FaIcon(FontAwesomeIcons.calendarDay),
      label: Text(date != null ? _dateFormat.format(date!) : ''),
    );
  }
}
