part of 'selectors.dart';

Iterable<DefaultRule> selectAllDefaultRules(AppState state) =>
    state.defaultRules.entities.values;
