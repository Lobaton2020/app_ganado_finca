import 'package:app_ganado_finca/src/infraestructure/db/adapter/sqliteAdapter.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/sqlite/BovineOutputSqlLiteDao.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/sqlite/BovineSqlLiteDao.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/supabase/BovineOutputSupabaseDao.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/supabase/BovineSupabaseDao.dart';
import 'package:app_ganado_finca/src/infraestructure/storage/repository/StorageLocalService.dart';
import 'package:app_ganado_finca/src/infraestructure/storage/repository/StorageSupabaseService.dart';

class SynchronizeService {
  final _bovineOutputSqlLiteDao = BovineOutputSqlLiteDao();
  final _bovineOutputSupabaseDao = BovineOutputSupabaseDao();

  final _bovineSqlLiteDao = BovineSqlLiteDao();
  final _bovineSupabaseDao = BovineSupabaseDao();
  final _storageLocalDao = StorageLocalService();
  final _storageSupabaseDao = StorageSupabaseService();
  main() {}
  Future<void> removeLocalData() async {
    await _bovineSqlLiteDao.truncate();
    await _bovineOutputSqlLiteDao.truncate();
  }

  Future<bool> pullInCaseRemoteChanged() async {
    final r1 = await pullInCaseRemoteChangedBovinesOutput();
    final r2 = await pullInCaseRemoteChangedBovines();
    return r1 || r2;
  }

  Future<bool> pullInCaseRemoteChangedBovines() async {
    final cloudCount = await _bovineSupabaseDao.count();
    final localCount = await _bovineSqlLiteDao.count();
    if (cloudCount != localCount) {
      await pullBovinesData();
      return true;
    }
    return false;
  }

  Future<bool> pullInCaseRemoteChangedBovinesOutput() async {
    final cloudCount = await _bovineOutputSupabaseDao.count();
    final localCount = await _bovineOutputSqlLiteDao.count();
    if (cloudCount != localCount) {
      await pullBovinesOutputData();
      return true;
    }
    return false;
  }

  Future<int> synchronizeOutputs() async {
    final data = await _bovineOutputSqlLiteDao.findAllForSynchronize();
    if (data.length == 0) {
      return data.length;
    }
    await Future.wait(data.map((item) async {
      await _bovineOutputSupabaseDao.create(item);
    }));
    await pullBovinesOutputData();
    return data.length;
  }

  Future<int> synchronizeBovines() async {
    final data = await _bovineSqlLiteDao.findAllForSynchronize();
    if (data.length == 0) {
      return data.length;
    }
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
    final data = await _bovineSupabaseDao.findAllCrude();
    await Future.wait(data.map((item) async {
      await _bovineSqlLiteDao.createSynchronize(item);
    }));
  }

  Future<void> pullBovinesOutputData() async {
    await _bovineOutputSqlLiteDao.truncate();
    final data = await _bovineOutputSupabaseDao.findAllCrude();
    await Future.wait(data.map((item) async {
      await _bovineOutputSqlLiteDao.createSynchronize(item);
    }));
  }
}
