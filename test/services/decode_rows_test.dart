import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/services/supabase.dart';

void main() {
  Map<String, dynamic> reply(String option) => {
    'member_id': 'member',
    'schedule_id': 'schedule',
    'instance_date': '2024-01-01T18:00:00Z',
    'selected_option': option,
  };

  test('a row with an unknown enum value is skipped, not the whole list', () {
    final replies = decodeRows([
      reply('yes'),
      reply('maybe'), // added on the server after this version shipped
      reply('no'),
    ], Reply.fromJson);

    expect(replies.map((r) => r.selectedOption), [
      ReplyOptions.yes,
      ReplyOptions.no,
    ]);
  });

  test('an unknown member role decodes as the least privileged one', () {
    final member = Member.fromJson({
      'id': 'member',
      'group_id': 'group',
      'role': 'owner',
    });

    expect(member.role, GroupRoles.member);
  });
}
