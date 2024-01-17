import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:image_picker/image_picker.dart';

abstract class StorageRepository {
  Future<String> uploadBovinePhoto(XFile file);
}
