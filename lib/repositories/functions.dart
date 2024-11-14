import 'package:supabase_flutter/supabase_flutter.dart';

extension FunctionsClientX on FunctionsClient {
  Future<FunctionResponse> deleteAccount(accessToken) =>
      invoke('delete_user_account',
          headers: {'Authorization': 'Bearer $accessToken'});
}
