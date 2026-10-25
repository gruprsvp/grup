import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

/// Shows a page per day, [date]'s in view. Swiping moves to the next or
/// previous day, which shows as it comes in.
class DayPager extends StatefulWidget {
  const DayPager({
    super.key,
    required this.date,
    required this.onDateChanged,
    required this.itemBuilder,
  });

  final DateTime date;

  /// Called once a swipe settles on another day.
  final ValueChanged<DateTime> onDateChanged;

  /// A day's content. The days either side are built as they come into view.
  final Widget Function(BuildContext context, DateTime day) itemBuilder;

  @override
  State<DayPager> createState() => _DayPagerState();
}

class _DayPagerState extends State<DayPager> {
  // Pages count from a large index, so the user can swipe back for a while.
  static const _start = 100000;
  final _controller = PageController(initialPage: _start);

  // The day on page [_start]; the other pages count from it, by calendar day:
  // around a DST change a day isn't 24 hours.
  late var _origin = widget.date;

  // The page the last swipe settled on, showing [DayPager.date].
  var _page = _start;

  DateTime _dayAt(int page) =>
      _origin.copyWith(day: _origin.day + page - _start);

  // A wheel or a web trackpad sends a stream of scroll events, momentum
  // included. The page view would follow each one and snap in between, so
  // a gesture moved by a fraction of a page or by many. One gesture, ended
  // by a pause, moves one day instead.
  static const _pause = Duration(milliseconds: 200);
  static const _threshold = 24.0;
  Duration? _lastScroll;
  var _scrolled = 0.0;
  var _moved = false;

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final delta = event.scrollDelta;
    if (delta.dx.abs() <= delta.dy.abs()) return; // the day's own list
    // Registered under the page view, so it wins over the page view's own.
    GestureBinding.instance.pointerSignalResolver.register(event, (event) {
      final last = _lastScroll;
      _lastScroll = event.timeStamp;
      if (last == null || event.timeStamp - last > _pause) {
        _scrolled = 0;
        _moved = false;
      }
      (event as PointerScrollEvent).respond(allowPlatformDefault: false);
      if (_moved) return;
      _scrolled += event.scrollDelta.dx;
      if (_scrolled.abs() < _threshold) return;
      _moved = true;
      // A jump, not an animation: while a page view animates it ignores
      // pointers over its pages, so the gesture's next events would reach
      // the page view itself and stop the animation halfway.
      _controller.jumpToPage(_page + _scrolled.sign.toInt());
    });
  }

  @override
  void didUpdateWidget(DayPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Moved some other way (the arrows, the date picker): the new day shows
    // on the current page.
    if (widget.date != _dayAt(_page)) {
      _origin = widget.date.copyWith(day: widget.date.day - (_page - _start));
    }
  }

  // Once the swipe settles, not halfway through like onPageChanged: a drag
  // past halfway and back would change the day twice, and load it each time.
  bool _onScrollEnd(ScrollEndNotification notification) {
    if (notification.depth != 0) return false; // a day's own list
    final page = _controller.page!.round();
    if (page != _page) {
      _page = page;
      widget.onDateChanged(_dayAt(page));
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Not allowImplicitScrolling, though it would build the days either side
  // ahead: under a NestedScrollView every built day's list scrolls together.
  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollEndNotification>(
        onNotification: _onScrollEnd,
        child: PageView.builder(
          controller: _controller,
          itemBuilder: (context, page) => Listener(
            onPointerSignal: _onPointerSignal,
            child: widget.itemBuilder(context, _dayAt(page)),
          ),
        ),
      );
}
