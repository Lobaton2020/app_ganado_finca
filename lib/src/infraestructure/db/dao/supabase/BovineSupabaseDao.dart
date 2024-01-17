import 'package:app_ganado_finca/src/application/domain/interfaces/BovineRepository.dart';
import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:app_ganado_finca/src/shared/utils/rxjs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_ganado_finca/src/infraestructure/db/dao/sqlite/BovineSqlLiteDao.dart';

class BovineSupabaseDao implements BovineRepository {
  final _bovineSqlLiteDao = BovineSqlLiteDao();
  @override
  Future<List<Bovine>> findAll() async {
    final data = await Supabase.instance.client
        .from('bovines')
        .select()
        .order('id', ascending: false);

    return data.map((item) => Bovine.fromJson(item)).toList();
  }

  @override
  Future<Bovine?> findOneByName(String name) async {
    final data = await Supabase.instance.client
        .from('bovines')
        .select()
        .eq('name', '$name');
    if (data.length == 0) {
      return null;
    }
    return Bovine.fromJson(data[0]);
  }

  @override
  Future<List<IOption>> findProvenances() async {
    final data = await Supabase.instance.client.from('provenances').select();
    return data
        .map((item) =>
            IOption(label: item["name"], value: item["id"].toString()))
        .toList();
  }

  @override
  Future<List<IOption>> findBovinesNames() async {
    final data =
        await Supabase.instance.client.from('bovines').select('id, name');
    return data
        .map((item) =>
            IOption(label: item["name"], value: item["id"].toString()))
        .toList();
  }

  @override
  Future<List<IOption>> findOwners() async {
    final data = await Supabase.instance.client.from('owners').select();
    return data
        .map((item) =>
            IOption(label: item["name"], value: item["id"].toString()))
        .toList();
  }

  @override
  Future<void> create(Bovine bovine) async {
    final newBovine = bovine.toJson();
    newBovine.remove("id");
    newBovine.remove("created_at");
    await Supabase.instance.client.from('bovines').insert(newBovine);
    await _bovineSqlLiteDao.create(bovine);
  }
}
