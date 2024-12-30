import 'package:parousia/actions/actions.dart';
import 'package:redux/redux.dart';

final feedbackReducer = combineReducers<bool?>([
  TypedReducer<bool?, InteractedWithFeedback>(_interactedWithFeedback).call,
]);

/// Whenever the user interacts with the feedback, we should hide it.
bool _interactedWithFeedback(
    bool? shouldShowFeedback, InteractedWithFeedback action) {
  return true;
}
