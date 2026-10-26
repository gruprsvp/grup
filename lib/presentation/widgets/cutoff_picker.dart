import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';

/// How long before an event changes to answers close, in words.
String cutoffLabel(AppLocalizations l10n, int? minutes) => switch (minutes) {
  null => l10n.cutoffNone,
  final minutes when minutes % 60 == 0 => l10n.cutoffHours(minutes ~/ 60),
  final minutes => l10n.cutoffMinutes(minutes),
};

/// Asks when changes to an event's answers close: minutes before it starts,
/// or `minutes: null` for never. `null` when dismissed.
Future<({int? minutes})?> pickCutoff(BuildContext context, {int? current}) =>
    showModalBottomSheet<({int? minutes})>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        Widget option(int? minutes) => ListTile(
          title: Text(cutoffLabel(l10n, minutes)),
          trailing: minutes == current ? const Icon(Icons.check) : null,
          onTap: () => Navigator.of(context).pop((minutes: minutes)),
        );
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    l10n.cutoffLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                for (final minutes in const [null, 60, 120, 240, 1440])
                  option(minutes),
                ListTile(
                  title: Text(l10n.cutoffCustom),
                  onTap: () async {
                    final hours = await _customHours(context, current);
                    if (hours != null && context.mounted) {
                      Navigator.of(context).pop((minutes: hours * 60));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

/// Hours before the start, 0 to a week (the server's limit).
Future<int?> _customHours(BuildContext context, int? current) =>
    showDialog<int>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        final formKey = GlobalKey<FormState>();
        var hours = current == null ? null : current ~/ 60;
        void save() {
          if (formKey.currentState!.validate()) {
            Navigator.of(context).pop(hours);
          }
        }

        return AlertDialog(
          title: Text(l10n.cutoffCustomTitle),
          content: Form(
            key: formKey,
            child: TextFormField(
              initialValue: hours?.toString(),
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.cutoffCustomTitle),
              onChanged: (value) => hours = int.tryParse(value),
              onFieldSubmitted: (_) => save(),
              validator: (value) => switch (int.tryParse(value ?? '')) {
                final hours? when hours >= 0 && hours <= 168 => null,
                _ => l10n.cutoffCustomInvalid,
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(onPressed: save, child: Text(l10n.save)),
          ],
        );
      },
    );
