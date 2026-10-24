import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

class DateDropdown extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime>? onDateChanged;

  const DateDropdown({super.key, this.date, this.onDateChanged});

  Future<void> _selectDate(BuildContext context) async {
    final date = this.date;
    final yearAgo = DateTime.now().add(const Duration(days: -365));
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      // Swiping can go back further than a year; the picker must allow it.
      firstDate: date != null && date.isBefore(yearAgo) ? date : yearAgo,
      lastDate: DateTime(2101),
    );

    if (newDate != null && newDate != date) {
      onDateChanged?.call(newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.event),
        label: Text(
          date == null
              ? ''
              : DateFormat.MMMMEEEEd(Localizations.localeOf(context).toString())
                    .format(date!),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: () => _selectDate(context),
      ),
    );
  }
}
