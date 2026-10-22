import 'package:material_ui/material_ui.dart';

/// Shows [child] for [date]; swiping moves to the next or previous day.
class DayPager extends StatefulWidget {
  const DayPager({
    super.key,
    required this.date,
    required this.onDateChanged,
    required this.child,
  });

  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  /// The content for [date]. The pages being swiped in show it too, until
  /// the swipe settles on the new day.
  final Widget child;

  @override
  State<DayPager> createState() => _DayPagerState();
}

class _DayPagerState extends State<DayPager> {
  // Pages count from a large index, so the user can swipe back for a while.
  static const _start = 100000;
  final _controller = PageController(initialPage: _start);
  var _page = _start;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageView.builder(
    controller: _controller,
    onPageChanged: (page) {
      final days = page - _page;
      _page = page;
      if (days != 0) {
        widget.onDateChanged(widget.date.add(Duration(days: days)));
      }
    },
    itemBuilder: (context, _) => widget.child,
  );
}
