import 'package:app_ganado_finca/src/application/domain/interfaces/BovineOutputRepository.dart';
import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/application/domain/models/BovineOutput.dart';
import 'package:app_ganado_finca/src/infraestructure/db/adapter/sqliteAdapter.dart';

class BovineOutputSqlLiteDao extends BovineOutputRepository {
  @override
  Future<void> create(BovineOutput bovineOutput) async {
    final connection = await sqlLiteInstance;
    final newBovineOutput = bovineOutput.toJson();
    newBovineOutput["for_synchronize"] = 1;
    newBovineOutput.remove("id");
    newBovineOutput.remove("created_at");
    newBovineOutput.remove("name");
    newBovineOutput.remove("photo");
    await connection.insert('bovines_output', newBovineOutput);
  }

  Future<void> createSynchronize(BovineOutput bovineOutput) async {
    final connection = await sqlLiteInstance;
    final newBovineOutput = bovineOutput.toJson();
    newBovineOutput["for_synchronize"] = 0;
    newBovineOutput.remove("id");
    newBovineOutput.remove("photo");
    newBovineOutput.remove("created_at");
    newBovineOutput.remove("name");
    await connection.insert('bovines_output', newBovineOutput);
  }

  @override
  Future<List<BovineOutput>> findAll() async {
    final connection = await sqlLiteInstance;
    final query = '''SELECT bovines_output.*, bovines.photo, bovines.name
      FROM bovines_output
      INNER JOIN bovines ON bovines_output.bovine_id = bovines.id ORDER BY bovines.id DESC;''';
    final data = await connection.rawQuery(query);
    final newData = data.map((item) {
      final newItem = Map<String, dynamic>.from(item);
      newItem["sold_amount"] = int.tryParse(newItem["sold_amount"].toString());
      newItem["was_sold"] = newItem["was_sold"] == 1;

      return BovineOutput.fromJson(newItem);
    }).toList();
    return newData;
  }

  @override
  Future<void> remove(int id) async {
    final connection = await sqlLiteInstance;
    await connection.delete("bovines_output", where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<Bovine?> findOneByName(String name) async {
    final connection = await sqlLiteInstance;
    final data = await connection.rawQuery('''
      select
            bovines.id,
            bovines.name,
            bovines.color,
            bovines.owner_id,
            bovines.photo,
            bovines.mother_id,
            bovines.is_male,
            bovines.for_increase,
            bovines.adquisition_amount,
            bovines.provenance_id,
            bovines_output.bovine_id,
            bovines.date_birth,
            bovines.created_at
          from
            bovines
            inner join bovines_output on bovines_output.bovine_id = bovines.id
          where
            bovines.name = ? ;''', [name]);
    final newData = data.map((item) {
      final newItem = Map<String, dynamic>.from(item);
      newItem.remove('for_synchronize');
      newItem["for_increase"] = item["for_increase"] == 1;
      newItem["is_male"] = newItem["is_male"] == 1;
      return Bovine.fromJson(newItem);
    }).toList();
    if (newData.isEmpty) {
      return null;
    }
    return newData[0];
  }
}
