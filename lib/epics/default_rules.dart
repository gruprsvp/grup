import 'package:parousia/actions/actions.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createDefaultRulesEpics(DefaultRulesRepository defaultRules) =>
    combineEpics<AppState>([
      _createRetrieveGroupDefaultRulesEpic(defaultRules),
      _createRequestUpdateOneDefaultRuleEpic(defaultRules),
      _createRequestDeleteDefaultRuleEpic(defaultRules),
    ]);

/// Fetch all default replies for a group
Epic<AppState> _createRetrieveGroupDefaultRulesEpic(
    DefaultRulesRepository defaultRules) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<GroupDetailsOpenAction>()
      .asyncMap(
        (action) => defaultRules
            .getDefaultRules(action.groupId)
            .then<dynamic>((defaultRules) =>
                SuccessRetrieveMany(defaultRules.toList(growable: false)))
            .catchError((error) => FailRetrieveMany<DefaultRule>([], error)),
      );
}

/// Create a new default reply
Epic<AppState> _createRequestUpdateOneDefaultRuleEpic(
    DefaultRulesRepository defaultRules) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestUpdateOne<DefaultRule>>().asyncMap(
            (action) => defaultRules
                .createDefaultRule(action.entity)
                .then<dynamic>((defaultRule) => SuccessUpdateOne(defaultRule))
                .catchError((error) => FailUpdateOne<DefaultRule>(
                    entity: action.entity, error: error)),
          );
}

/// Delete a default reply
Epic<AppState> _createRequestDeleteDefaultRuleEpic(
    DefaultRulesRepository defaultRules) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestDeleteDefaultRuleAction>().asyncMap(
            (action) => defaultRules
                .deleteDefaultRule(action.defaultRule)
                .then<dynamic>((_) => SuccessDeleteOne<DefaultRule>(
                    "${action.defaultRule.member.id}-${action.defaultRule.schedule.id}"))
                .catchError((error) => FailDeleteOne<DefaultRule>(
                    id: "${action.defaultRule.member.id}-${action.defaultRule.schedule.id}",
                    error: error)),
          );
}
