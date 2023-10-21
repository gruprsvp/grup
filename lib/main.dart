import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:parousia/app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(borgoat): move this to a config file to support different environments
  final supabaseFuture = Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxeXd1YXF5d3RjemZocGNubHFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODg3NjIzMTEsImV4cCI6MjAwNDMzODMxMX0.m5Yg9Qu3xMzOFTA4cqxcen3ndOG2MVtWqbItK3r1al4',
    url: 'https://gqywuaqywtczfhpcnlqm.supabase.co',
    debug: kDebugMode,
  );

  final storageFuture = HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationSupportDirectory(),
  );

  // To allow storage and supabase to be initialised concurrently
  HydratedBloc.storage = await storageFuture;
  await supabaseFuture;

  runApp(const ParApp());
}
