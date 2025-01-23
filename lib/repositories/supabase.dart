import 'package:parousia/brick/repository.dart';

abstract class SupabaseRepository {
  final ParRepository repository;

  const SupabaseRepository({
    required this.repository,
  });
}
