import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parousia/app.dart';
import 'package:parousia/data/groups.dart';
import 'package:parousia/epics/epics.dart';
import 'package:parousia/reducers/reducers.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'actions/actions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(borgoat): move this to a config file to support different environments
  final supabasePromise = Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxeXd1YXF5d3RjemZocGNubHFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODg3NjIzMTEsImV4cCI6MjAwNDMzODMxMX0.m5Yg9Qu3xMzOFTA4cqxcen3ndOG2MVtWqbItK3r1al4',
    url: 'https://gqywuaqywtczfhpcnlqm.supabase.co',
    debug: kDebugMode,
  );

  final persistor = Persistor<RootState>(
    debug: kDebugMode,
    storage: FlutterStorage(),
    serializer: JsonSerializer<RootState>(
      (json) => json != null
          ? RootState.fromJson(json as Map<String, dynamic>)
          : null,
    ),
  );

  final localPersistedState = await persistor.load();
  await supabasePromise;

  final supabase = Supabase.instance.client;
  final dataProviderGroups = DataProviderGroups(supabase: supabase);
  final groupsRepository = GroupsRepository(groups: dataProviderGroups);

  final epics = combineEpics<RootState>([
    createLoadGroupsEpic(groupsRepository),
  ]);

  final store = Store<RootState>(
    rootReducer,
    initialState: localPersistedState ?? RootState.initialState(),
    middleware: [
      persistor.createMiddleware(),
      EpicMiddleware<RootState>(epics),
    ],
  );

  // Propagate auth state changes to the store
  supabase.auth.onAuthStateChange.listen(
      (authState) => store.dispatch(AuthStateChangedAction(authState.event)));

  runApp(
    ParApp(store: store),
  );
}
