import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase/supabase.dart';

import 'const.dart';
import 'supabase.dart';

/// Repository for uploading files to Supabase Storage.
class StorageRepository extends SupabaseRepository with Storage {
  const StorageRepository({required super.supabase})
      : super(bucketName: Buckets.public);

  Future<String> uploadPublicXFile(String key, XFile file) async {
    final ext =
        file.mimeType != null ? extensionFromMime(file.mimeType!) : 'jpg';
    final path = '${supabase.auth.currentUser!.id}/$key.$ext';
    final bytes = await file.readAsBytes();

    final response = await bucket().uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(
        contentType: file.mimeType,
      ),
    );

    return bucket().getPublicUrl(path);
  }
}
