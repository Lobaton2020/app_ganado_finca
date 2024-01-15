import 'package:app_ganado_finca/src/models/Bovine.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BovineService{
Future<List<Bovine>> findAll() async {
  final data = await Supabase.instance.client
      .from('bovines')
      .select();

    return data.map((item) => Bovine.fromJson(item)).toList();
  }

  Future<List<IOption>> findProvenances() async {
    final data = await Supabase.instance.client.from('provenances').select();
    return data
        .map((item) =>
            IOption(label: item["name"], value: item["id"].toString()))
        .toList();
  }

  Future<List<IOption>> findOwners() async {
    final data = await Supabase.instance.client.from('owners').select();
    return data
        .map((item) =>
            IOption(label: item["name"], value: item["id"].toString()))
        .toList();
  }

  Future<void> create(Bovine bovine) async {
    final newBovine = bovine.toJson();
    newBovine.remove("id");
    newBovine.remove("created_at");
    await Supabase.instance.client.from('bovines').insert(newBovine);
  }
}