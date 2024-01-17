
import 'package:app_ganado_finca/src/application/domain/interfaces/BovineRepository.dart';
import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/infraestructure/db/adapter/sqliteAdapter.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:app_ganado_finca/src/shared/utils/rxjs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BovineSqlLiteDao implements BovineRepository {
  @override
  Future<List<Bovine>> findAll() async {
    final connection = await sqlLiteInstance;
    final data = await connection.query('bovines', orderBy: 'id DESC');
    final newData = data.map((item) {
      final newItem = Map<String, dynamic>.from(item);
      newItem["for_increase"] = item["for_increase"] == 1;
      newItem["is_male"] = newItem["is_male"] == 1;
      return Bovine.fromJson(newItem);
    }).toList();
    return newData;
  }

  Future<List<Bovine>> findAllForSynchronize() async {
    final connection = await sqlLiteInstance;
    final data = await connection.query('bovines',
        where: 'for_synchronize = 1', orderBy: 'id DESC');
    final newData = data.map((item) {
      final newItem = Map<String, dynamic>.from(item);
      newItem.remove('for_synchronize');
      newItem["for_increase"] = item["for_increase"] == 1;
      newItem["is_male"] = newItem["is_male"] == 1;
      return Bovine.fromJson(newItem);
    }).toList();
    return newData;
  }

  @override
  Future<Bovine?> findBovineByName(String name) async {
    final connection = await sqlLiteInstance;
    final data =
        await connection.query('bovines', where: 'name = ?', whereArgs: [name]);

    if (data.length == 0) {
      return null;
    }
    return Bovine.fromJson(data[0]);
  }

  @override
  Future<List<IOption>> findProvenances() async {
    final connection = await sqlLiteInstance;
    final data = await connection.query('provenances');
    return data
        .map((item) => IOption(
            label: item["name"] as String, value: item["id"].toString()))
        .toList();
  }

  @override
  Future<List<IOption>> findBovinesNames() async {
    final connection = await sqlLiteInstance;
    final data = await connection.query('bovines', columns: ['id', 'name']);
    return data
        .map((item) => IOption(
            label: item["name"] as String, value: item["id"].toString()))
        .toList();
  }

  @override
  Future<List<IOption>> findOwners() async {
    final connection = await sqlLiteInstance;
    final data = await connection.query('owners');
    return data
        .map((item) => IOption(
            label: item["name"] as String, value: item["id"].toString()))
        .toList();
  }

  @override
  Future<void> create(Bovine bovine) async {
    final connection = await sqlLiteInstance;
    final newBovine = bovine.toJson();
    newBovine["for_synchronize"] = true;
    newBovine.remove("id");
    newBovine.remove("created_at");
    await connection.insert('bovines', newBovine);
  }

  Future<void> createSynchronize(Bovine bovine) async {
    final connection = await sqlLiteInstance;
    final newBovine = bovine.toJson();
    newBovine["for_synchronize"] = 0;
    newBovine.remove("id");
    newBovine.remove("created_at");
    await connection.insert('bovines', newBovine);
  }

  @override
  Future<void> update(Bovine bovine) async {
    final connection = await sqlLiteInstance;
    await connection.update('bovines', bovine.toJson(),
        where: 'id = ?', whereArgs: [bovine.id]);
  }

  @override
  Future<void> delete(Bovine bovine) async {
    final connection = await sqlLiteInstance;
    await connection.delete('bovines', where: 'id = ?', whereArgs: [bovine.id]);
  }

  @override
  Future<Bovine?> findOneByName(String name) async {
    final connection = await sqlLiteInstance;
    final data =
        await connection.query('bovines', where: 'name = ?', whereArgs: [name]);

    if (data.length == 0) {
      return null;
    }
    return Bovine.fromJson(data[0]);
  }

  Future<void> truncate() async {
    final connection = await sqlLiteInstance;
    await connection.delete('bovines', where: '1 = 1');
  }
}
