import 'package:app_ganado_finca/src/models/Bovine.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BovineService{
Future<List<Bovine>> findAll() async {
  final data = await Supabase.instance.client
      .from('bovines')
      .select();

    return data.map((item) => Bovine.fromJson(item)).toList();
  }
}