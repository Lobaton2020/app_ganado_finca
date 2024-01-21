import 'package:app_ganado_finca/src/application/domain/interfaces/BovineOutputRepository.dart';
import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/application/domain/models/BovineOutput.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/sqlite/BovineOutputSqlLiteDao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BovineOutputSupabaseDao extends BovineOutputRepository {
  final _bovineOutputSqlLiteDao = BovineOutputSqlLiteDao();
  @override
  Future<void> create(BovineOutput bovineOutput) async {
    final newBovineOutput = bovineOutput.toJson();
    newBovineOutput.remove("id");
    newBovineOutput.remove("created_at");
    newBovineOutput.remove("photo");
    newBovineOutput.remove("name");
    await Supabase.instance.client
        .from('bovines_output')
        .insert(newBovineOutput);
    await _bovineOutputSqlLiteDao.createSynchronize(bovineOutput);
  }

  @override
  Future<List<BovineOutput>> findAll() async {
    final data = await Supabase.instance.client
        .from('bovines_output_view')
        .select()
        .order('id', ascending: false);

    return data.map((item) => BovineOutput.fromJson(item)).toList();
  }

  Future<List<BovineOutput>> findAllCrude() async {
    final data = await Supabase.instance.client.from('bovines_output').select();
    return data.map((item) => BovineOutput.fromJson(item)).toList();
  }
@override
  Future<Bovine?> findOneByName(String name) async {
        final data = await Supabase.instance.client
        .from('bovines_intersection_outputs_view')
        .select()
        .like('name', '%$name%');
    if (data.length == 0) {
      return null;
    }
    return Bovine.fromJson(data[0]);
  }
  @override
  Future<void> remove(int id) async {
    await Supabase.instance.client.from("bovines_output").delete().eq("id", id);
  }
}
