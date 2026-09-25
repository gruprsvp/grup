import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:parousia/util/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initializes the app's singletons (config, fonts, Supabase) for hermetic
/// widget tests. flutter_test answers every HTTP request with a 400, so any
/// backend call fails fast instead of reaching a server.
Future<void> initFakeSupabase() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  ConfigService().config = const Config(
    supabaseConfigPath: 'unused',
    socialAuthWebClientId: 'test-web-client-id',
    socialAuthIosClientId: 'test-ios-client-id',
  );
  await Supabase.initialize(
    url: 'http://localhost:54321',
    publishableKey: 'test-publishable-key',
    authOptions: FlutterAuthClientOptions(
      localStorage: const EmptyLocalStorage(),
      pkceAsyncStorage: _MemoryAsyncStorage(),
      detectSessionInUri: false,
    ),
  );
}

/// In-memory PKCE storage, so tests don't need SharedPreferences.
class _MemoryAsyncStorage extends GotrueAsyncStorage {
  _MemoryAsyncStorage();

  final _items = <String, String>{};

  @override
  Future<String?> getItem({required String key}) async => _items[key];

  @override
  Future<void> setItem({required String key, required String value}) async =>
      _items[key] = value;

  @override
  Future<void> removeItem({required String key}) async => _items.remove(key);
}
