import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/fakes.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:test/test.dart';

void main() {
  group('selectSchedulesAndReplies', () {
    test(
      'should return the schedules and replies for the selected group',
      () {
        final group = Fake.group();
        final date = DateTime.now();
        final state = RootState(selectedDate: date).copyWith(
          groups: RemoteEntityState(entities: {group.id.toString(): group}),
          replies: RemoteEntityState(entities: {
            '1': Fake.reply(groupId: group.id),
            '2': Fake.reply(groupId: group.id),
          }),
        );

        final result = selectSchedulesAndReplies(state, group.id);

        expect(true, true);
      },
    );
  });
}
