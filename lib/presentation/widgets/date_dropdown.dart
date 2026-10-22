import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

class DateDropdown extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime>? onDateChanged;

  const DateDropdown({super.key, this.date, this.onDateChanged});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.event),
        label: Text(
          date == null
              ? ''
              : DateFormat.MMMMEEEEd(Localizations.localeOf(context).toString())
                    .format(date!),
        ),
        onPressed: () => _selectDate(context),
      ),
    );
  }
}
