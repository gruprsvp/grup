part of 'selectors.dart';

Map<String, Group> selectGroupEntities(AppState state) => state.groups.entities;

final selectGroup = createSelector2(
    selectGroupId, selectGroupEntities, (id, entities) => entities[id]);
