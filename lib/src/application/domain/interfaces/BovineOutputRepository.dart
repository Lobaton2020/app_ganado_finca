import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/application/domain/models/BovineOutput.dart';

abstract class BovineOutputRepository {
  Future<List<BovineOutput>> findAll();
  Future<void> create(BovineOutput bovineOutput);
  Future<void> remove(int id);
  Future<Bovine?> findOneByName(String name);
}
