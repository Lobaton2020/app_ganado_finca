import 'dart:io';

import 'package:app_ganado_finca/src/application/domain/interfaces/StorageRepository.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageLocalService implements StorageRepository {
  Future<String> uploadBovinePhoto(XFile file) async {
    print("He guardado l imagen localmente");
    return "Ej: no internet";
  }
}
