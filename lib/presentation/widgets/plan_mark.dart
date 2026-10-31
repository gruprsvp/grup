import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// A plan's name as a mark: Sniglet, in the brand colour. Plan names are the
/// only words besides GRUP's own name that wear it.
class PlanMark extends StatelessWidget {
  const PlanMark(this.name, {super.key, this.style});

  final String name;

  /// The size to set it at; Title large when null.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      name,
      style: GoogleFonts.sniglet(
        textStyle: style ?? theme.textTheme.titleLarge,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
