import 'package:app_ganado_finca/src/application/domain/interfaces/StorageRepository.dart';
import 'package:app_ganado_finca/src/application/services/SynchronizeService.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/sqlite/BovineSqlLiteDao.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/supabase/BovineSupabaseDao.dart';
import 'package:app_ganado_finca/src/application/domain/interfaces/BovineRepository.dart';
import 'package:app_ganado_finca/src/infraestructure/storage/repository/StorageLocalService.dart';
import 'package:app_ganado_finca/src/infraestructure/storage/repository/StorageSupabaseService.dart';
import 'package:app_ganado_finca/src/shared/utils/rxjs.dart';

BovineRepository bovineService = BovineSupabaseDao();
StorageRepository storageService = StorageSupabaseService();
SynchronizeService synchronizeService = SynchronizeService();

void initObserverOffline() {
  internetState.listen((value) {
    if (value == InternetState.disconnected) {
      bovineService = BovineSqlLiteDao();
      storageService = StorageLocalService();
    } else {
      bovineService = BovineSupabaseDao();
      storageService = StorageSupabaseService();
    }
  });
}
