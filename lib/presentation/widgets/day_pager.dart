import 'package:flutter/gestures.dart';
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

  /// The content for [date]. A page being swiped in stays blank until it
  /// becomes the current day, rather than showing the day it's leaving.
  final Widget child;

  @override
  State<DayPager> createState() => _DayPagerState();
}

class _DayPagerState extends State<DayPager> {
  // Pages count from a large index, so the user can swipe back for a while.
  static const _start = 100000;
  final _controller = PageController(initialPage: _start);
  var _page = _start;

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
        // By calendar day: around a DST change a day isn't 24 hours.
        widget.onDateChanged(widget.date.copyWith(day: widget.date.day + days));
      }
    },
    itemBuilder: (context, page) => page == _page
        ? Listener(onPointerSignal: _onPointerSignal, child: widget.child)
        : const SizedBox.shrink(),
  );
}
