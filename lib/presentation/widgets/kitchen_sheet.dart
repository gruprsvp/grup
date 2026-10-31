import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/view_models/group_kitchen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// The kitchen view of a day as a printable PDF: each event with its
/// headcount, who's coming and who changed late.
Future<Uint8List> kitchenSheet({
  required AppLocalizations l10n,
  required String locale,
  required String groupName,
  required DateTime date,
  required List<KitchenEvent> events,
  required String Function((Member, Profile?) member) nameOf,
}) async {
  // The app's own font: the PDF's built-in one has no accents beyond Latin-1.
  Future<pw.Font> font(String name) async =>
      pw.Font.ttf(await rootBundle.load('assets/google_fonts/$name.ttf'));
  final document = pw.Document(
    theme: pw.ThemeData.withFont(
      base: await font('Cabin-Regular'),
      bold: await font('Cabin-Bold'),
    ),
  );
  final time = DateFormat.jm(locale);
  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (context) => pw.Text(
        '$groupName · ${l10n.kitchenTitle} · '
        '${DateFormat.yMMMMEEEEd(locale).format(date)}',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
      ),
      build: (context) => [
        for (final event in events) ...[
          pw.SizedBox(height: 16),
          pw.Text(
            '${time.format(event.instance.instanceDate)} · '
            '${event.schedule.displayName}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
          ),
          pw.Text(
            [
              l10n.eventComing(event.coming.length),
              l10n.kitchenMembers(event.members),
              l10n.kitchenGuests(event.guests),
              l10n.eventOut(event.no),
              l10n.eventNoReply(event.noReply),
            ].join(' · '),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            event.coming.isEmpty
                ? l10n.kitchenNobody
                : event.coming.map(nameOf).join(', '),
          ),
          if (event.late.isNotEmpty)
            pw.Text(
              '${l10n.kitchenLate}: ${event.late.map(nameOf).join(', ')}',
            ),
        ],
      ],
    ),
  );
  return document.save();
}
