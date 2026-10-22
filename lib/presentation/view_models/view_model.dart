import 'package:flutter/foundation.dart';

/// A view model notifies whenever anything its view shows changes: the
/// repositories it reads, and its commands' running and error states.
///
/// It stops listening when disposed, so a command that finishes after its
/// screen closed doesn't notify a disposed view model.
abstract class ViewModel extends ChangeNotifier {
  final _sources = <(Listenable, VoidCallback)>[];

  /// Calls [onChange] (by default, notifies this view model's listeners)
  /// whenever one of [sources] notifies, until disposed.
  @protected
  void listenTo(Iterable<Listenable> sources, [VoidCallback? onChange]) {
    final callback = onChange ?? notifyListeners;
    for (final source in sources) {
      source.addListener(callback);
      _sources.add((source, callback));
    }
  }

  @override
  void dispose() {
    for (final (source, callback) in _sources) {
      source.removeListener(callback);
    }
    super.dispose();
  }
}
