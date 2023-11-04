import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase/supabase.dart';

import 'const.dart';

/// Repository for uploading files to Supabase Storage.
class StorageRepository {
  const StorageRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<String> uploadPublicXFile(String key, XFile file) async {
    final ext =
        file.mimeType != null ? extensionFromMime(file.mimeType!) : 'jpg';
    final path = '${supabase.auth.currentUser!.id}/$key.$ext';
    final bytes = await file.readAsBytes();

    final response = await _publicBucket().uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(
        contentType: file.mimeType,
      ),
    );

    return _publicBucket().getPublicUrl(path);
  }

  _publicBucket() => supabase.storage.from(Buckets.public.name);

  _privateBucket() => supabase.storage.from(Buckets.private.name);
}
