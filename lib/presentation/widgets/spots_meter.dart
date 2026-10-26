import 'dart:math';

import 'package:material_ui/material_ui.dart';

/// A group's spots as dots, one per spot, filled for each one taken, in
/// tens like a tally. The words beside it say the same, so screen readers
/// skip it.
class SpotsMeter extends StatelessWidget {
  const SpotsMeter({
    super.key,
    required this.taken,
    required this.limit,
    this.size = 12,
    this.gap = 5,
    this.animation,
    this.from = 0,
  });

  final int taken;
  final int limit;
  final double size;
  final double gap;

  /// Pops the dots from [from] on in, one after another, as it runs; the
  /// ones before stay. Null shows them all.
  final Animation<double>? animation;
  final int from;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final animation = this.animation;
    // Over the limit (after a smaller plan), every spot shows taken.
    final filled = min(taken, limit);

    Widget dot(int index) {
      final child = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index < filled ? colorScheme.primary : null,
          border: index < filled
              ? null
              : Border.all(color: colorScheme.outlineVariant, width: 1.5),
        ),
      );
      if (animation == null || index < from) return child;
      final start = (index - from) / (limit - from) * 0.6;
      return ScaleTransition(
        scale: animation.drive(
          CurveTween(
            curve: Interval(start, start + 0.4, curve: Curves.easeOutBack),
          ),
        ),
        child: child,
      );
    }

    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Tens sit a wider gap apart; a row holds 40, 20 or 10 of them.
          final ten = 10 * size + 9 * gap;
          final perRow = [40, 20].firstWhere(
            (n) =>
                n ~/ 10 * ten + (n ~/ 10 - 1) * gap * 3 <= constraints.maxWidth,
            orElse: () => 10,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: gap,
            children: [
              for (var row = 0; row < limit; row += perRow)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = row; i < min(row + perRow, limit); i++)
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: i == row + perRow - 1
                              ? 0
                              : i % 10 == 9
                              ? gap * 3
                              : gap,
                        ),
                        child: dot(i),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
