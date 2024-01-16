import 'dart:io';

import 'package:app_ganado_finca/src/models/Bovine.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  Future<String> uploadBovinePhoto(XFile file) async {
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    await Supabase.instance.client.storage.from('bovines_photos').uploadBinary(
        filePath, await file.readAsBytes(),
        fileOptions: new FileOptions(upsert: true, contentType: file.mimeType));
    final imageUrlResponse = await Supabase.instance.client.storage
        .from('bovines_photos')
        .getPublicUrl(filePath);
    return imageUrlResponse;
  }
}
