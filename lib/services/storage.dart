import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:parousia/util/errors.dart';
import 'package:supabase/supabase.dart';

import 'const.dart';
import 'supabase.dart';

/// Uploads and deletes files in Supabase Storage.
class StorageService extends SupabaseService with Storage {
  const StorageService({required super.supabase})
    : super(bucketName: Buckets.public);

  /// Uploads a file to the public bucket, in the current user's folder.
  Future<String> uploadPublicXFile(String key, XFile file) async {
    final ext = file.mimeType != null
        ? extensionFromMime(file.mimeType!)
        : 'jpg';
    final path = '${_userId()}/$key.$ext';
    final bytes = await file.readAsBytes();

    await bucket().uploadBinary(
      path,
      bytes,
      fileOptions: FileOptions(contentType: file.mimeType),
    );

    return bucket().getPublicUrl(path);
  }

  /// Deletes the file at [url], if it is one of this bucket's. Storage skips
  /// files the user may not delete: other users' files, and group pictures.
  Future<void> deletePublicUrl(String url) async {
    final prefix = bucket().getPublicUrl('');
    if (!url.startsWith(prefix)) return; // e.g. a sign-in provider's avatar
    await bucket().remove([Uri.decodeComponent(url.substring(prefix.length))]);
  }

  /// Deletes all files owned by the current user.
  Future<void> deleteUserFiles() async {
    final userId = _userId();
    // A listing returns at most one page (100 files): delete page by page,
    // and stop once a page deletes nothing, rather than loop forever.
    while (true) {
      final files = await bucket().list(path: userId);
      if (files.isEmpty) return;
      final removed = await bucket().remove([
        for (final file in files) '$userId/${file.name}',
      ]);
      if (removed.isEmpty) return;
    }
  }

  String _userId() =>
      supabase.auth.currentUser?.id ?? (throw const NotSignedInException());
}
