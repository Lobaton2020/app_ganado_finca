import 'package:app_ganado_finca/src/application/domain/interfaces/ResumeRepository.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResumeSupabaseDao implements ResumeRepository {
  @override
  Future<List<IOption>> totalGroupedByOwner() async {
    final results =
        await Supabase.instance.client.from('counts_by_owner_view').select();
    print(results);
    return results
        .map((row) =>
            IOption(label: row['name'], value: row['total'].toString()))
        .toList();
  }

  @override
  Future<int> totalHembras() async {
    final results = await Supabase.instance.client
        .from('bovines_left_outputs_view')
        .select('id')
        .eq('is_male', false)
        .count();
    return results.count;
  }

  @override
  Future<int> totalMachos() async {
    final results = await Supabase.instance.client
        .from('bovines_left_outputs_view')
        .select('id')
        .eq('is_male', true)
        .count();
    return results.count;
  }

  @override
  Future<int> totalSalidas() async {
    final results = await Supabase.instance.client
        .from('bovines_intersection_outputs_view')
        .select('id')
        .count();
    return results.count;
  }
}
