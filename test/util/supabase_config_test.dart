import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/util/util.dart';

void main() {
  test('the production config holds a publishable key', () {
    // The release builds ship this file. The legacy anon key (a JWT) stops
    // working when Supabase turns the legacy keys off, by the end of 2026.
    final config = SupabaseConfig.fromPath('supabase/config/supabase.json');
    expect(config.publishableKey, startsWith('sb_publishable_'));
  });
}
