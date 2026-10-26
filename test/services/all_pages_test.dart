import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/services/supabase.dart';

void main() {
  /// A table of [count] rows, served a page (from, to: inclusive) at a time
  /// as PostgREST does, recording which pages were asked for.
  (Future<List<Map<String, dynamic>>> Function(int, int), List<(int, int)>)
  table(int count) {
    final asked = <(int, int)>[];
    return (
      (from, to) async {
        asked.add((from, to));
        return [
          for (var i = from; i <= to && i < count; i++) {'i': i},
        ];
      },
      asked,
    );
  }

  test('fetches page after page until one comes back short', () async {
    final (page, asked) = table(25);
    final rows = await allPages(page, pageSize: 10);

    expect(rows.map((row) => row['i']), List.generate(25, (i) => i));
    expect(asked, [(0, 9), (10, 19), (20, 29)]);
  });

  test(
    'a last page that is exactly full costs one more, empty request',
    () async {
      final (page, asked) = table(20);
      final rows = await allPages(page, pageSize: 10);

      expect(rows, hasLength(20));
      expect(asked, [(0, 9), (10, 19), (20, 29)]);
    },
  );

  test('one short page is one request', () async {
    final (page, asked) = table(3);
    expect(await allPages(page), hasLength(3));
    expect(asked, [(0, 999)]);
  });
}
