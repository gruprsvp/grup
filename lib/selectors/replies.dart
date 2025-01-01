part of 'selectors.dart';

Iterable<Reply> selectAllReplies(AppState state) =>
    state.replies.entities.values;
