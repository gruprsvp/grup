import 'package:parousia/util/util.dart';
import 'package:test/test.dart';

void main() {
  group('getNameInitials', () {
    test('should return the initials of a name',
        () => expect(getNameInitials('John Doe'), 'JD'));

    test('should support simple emojis',
        () => expect(getNameInitials('👨 Test'), '👨T'));

    test('should support complex emojis',
        () => expect(getNameInitials('👨‍👩‍👧‍👦 Ciao'), '👨‍👩‍👧‍👦C'));
  });
}
