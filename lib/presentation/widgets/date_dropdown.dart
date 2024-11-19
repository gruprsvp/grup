import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDropdown extends StatelessWidget {
  final _dateFormat = DateFormat.MMMMEEEEd();
  final DateTime? date;
  final ValueChanged<DateTime>? onDateChanged;

  DateDropdown({
    super.key,
    this.date,
    this.onDateChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now().add(const Duration(days: -365)),
      lastDate: DateTime(2101),
    );

    if (newDate != null && newDate != date) {
      onDateChanged?.call(newDate);
    }
  }

  void _changeDate(int days) {
    onDateChanged?.call(date!.add(Duration(days: days)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _changeDate(-1),
        ),
        Expanded(
          child: ListTile(
            title: Text(date != null ? _dateFormat.format(date!) : ''),
            leading: const Icon(Icons.event),
            onTap: () => _selectDate(context),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => _changeDate(1),
        ),
      ],
    );
  }
}
