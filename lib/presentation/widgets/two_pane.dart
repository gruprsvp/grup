import 'dart:math';

import 'package:material_ui/material_ui.dart';

/// One occurrence of a schedule: which one a list has open.
typedef ScheduleInstanceKey = ({String scheduleId, DateTime at});

/// A list and the item it opened, side by side. For wide windows only
/// ([isWide]); narrower ones show one page at a time.
class TwoPane extends StatelessWidget {
  /// Material 3's "expanded" window width.
  static const expandedWidth = 840.0;

  /// From the window, not the platform: iPad split view and browser windows
  /// resize while open.
  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= expandedWidth;

  final Widget list;

  /// `null` leaves the pane empty, e.g. on a day with no events.
  final Widget? detail;

  const TwoPane({super.key, required this.list, this.detail});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    // One outer Scaffold: the panes' own Scaffolds nest in it, so a snackbar
    // shows once, across the window.
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: min(max(width * 0.4, 360), 480), child: list),
          const VerticalDivider(width: 1),
          // Capped like a single-column page: answers stay near the names.
          Expanded(
            child: ReadableWidth(child: detail ?? const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}

/// A single-column page, capped at a readable width and centred on wider
/// windows.
// shortcut: the mouse wheel doesn't scroll over the side margins on web; pad
// each screen's scrollables instead if that matters.
class ReadableWidth extends StatelessWidget {
  static const maxWidth = 640.0;

  final Widget child;

  const ReadableWidth({super.key, required this.child});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surface,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    ),
  );
}
