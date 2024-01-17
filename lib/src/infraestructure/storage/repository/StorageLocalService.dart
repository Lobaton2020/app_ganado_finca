import 'dart:io';

import 'package:app_ganado_finca/src/application/domain/interfaces/StorageRepository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class StorageLocalService implements StorageRepository {
  Future<void> removeFile(String path) async {
    File file = File(path);
    await file.delete();
  }

  Future<XFile> getLocalBovinePhoto(String path) async {
    Directory tempDir = await getTemporaryDirectory();
    final fileExt = path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    String tempPath = '${tempDir.path}/$fileName';
    File file = File(path);
    await file.copy(tempPath);
    XFile xfile = XFile(tempPath);
    return xfile;
  }
  Future<String> uploadBovinePhoto(XFile file) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory =
            await getApplicationDocumentsDirectory();
      }
    } catch (e) {
      print("Error getting directory: $e");
    }
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    String fullPath = '${directory!.path}/$fileName';
    File localFile = File(fullPath);
    try {
      await localFile.writeAsBytes(await file.readAsBytes());
    } catch (e) {
      print("Error saving image: $e");
    }
    return fullPath;
  }
}
