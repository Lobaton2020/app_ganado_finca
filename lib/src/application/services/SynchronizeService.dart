import 'package:app_ganado_finca/src/infraestructure/db/adapter/sqliteAdapter.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/sqlite/BovineSqlLiteDao.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/supabase/BovineSupabaseDao.dart';
import 'package:app_ganado_finca/src/infraestructure/storage/repository/StorageLocalService.dart';
import 'package:app_ganado_finca/src/infraestructure/storage/repository/StorageSupabaseService.dart';

class SynchronizeService {
  final _bovineSqlLiteDao = BovineSqlLiteDao();
  final _bovineSupabaseDao = BovineSupabaseDao();
  final _storageLocalDao = StorageLocalService();
  final _storageSupabaseDao = StorageSupabaseService();
  main() {}
  Future<int> synchronizeBovines() async {
    final data = await _bovineSqlLiteDao.findAllForSynchronize();

    await Future.wait(data.map((item) async {
      if (item.photo != null) {
        final xFile = await _storageLocalDao.getLocalBovinePhoto(item.photo);
        final url = await _storageSupabaseDao.uploadBovinePhoto(xFile);
        await _storageLocalDao.removeFile(item.photo);
        item.photo = url;
      }
      await _bovineSupabaseDao.create(item);
    }));
    await pullBovinesData();
    return data.length;
  }

  Future<void> pullBovinesData() async {
    await _bovineSqlLiteDao.truncate();
    final data = await _bovineSupabaseDao.findAll();
    await Future.wait(data.map((item) async {
      await _bovineSqlLiteDao.createSynchronize(item);
    }));
  }
}
