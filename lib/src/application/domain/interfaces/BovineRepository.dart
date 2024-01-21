import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';

abstract class BovineRepository {
  Future<List<Bovine>> findAll();
  Future<List<IOption>> findProvenances();
  Future<List<IOption>> findBovinesNames();
  Future<List<IOption>> findOwners();
  Future<void> create(Bovine bovine);
  Future<Bovine?> findOneByName(String newBovine);
  Future<int> count();
}
