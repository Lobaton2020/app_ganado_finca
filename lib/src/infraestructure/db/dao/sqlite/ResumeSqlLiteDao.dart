import 'package:app_ganado_finca/src/application/domain/dtos/ResumeGeneric.dart';
import 'package:app_ganado_finca/src/application/domain/interfaces/ResumeRepository.dart';
import 'package:app_ganado_finca/src/infraestructure/db/adapter/sqliteAdapter.dart';
import 'package:app_ganado_finca/src/infraestructure/db/queries/views.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';

class ResumeSqlLiteDao implements ResumeRepository {
  @override
  Future<List<IOption>> totalGroupedByOwner() async {
    final connection = await DatabaseHelper.getInstance();
    final query = '''
        SELECT
          owners.name,
          COUNT(*) AS total
        FROM bovines
        LEFT JOIN bovines_output ON bovines_output.bovine_id = bovines.id
        LEFT JOIN owners ON owners.id = bovines.owner_id
        WHERE bovines_output.id IS NULL
        GROUP BY owners.name;
''';
    final results = await connection.rawQuery(query);
    return results
        .map((x) =>
            IOption(label: x["name"] as String, value: x["total"].toString()))
        .toList();
  }

  Future<int> _countBySex(String gender) async {
    final connection = await DatabaseHelper.getInstance();
    final query = '''SELECT COUNT(*) as total
      FROM bovines
      LEFT JOIN bovines_output ON bovines_output.bovine_id = bovines.id
      WHERE bovines_output.id IS NULL AND is_male = ?;''';
    final result = await connection.rawQuery(query, [gender]);
    return result.first["total"] as int;
  }

  @override
  Future<int> totalHembras() async {
    return _countBySex("0");
  }

  @override
  Future<int> totalMachos() {
    return _countBySex("1");
  }

  @override
  Future<int> totalSalidas() async {
    final connection = await DatabaseHelper.getInstance();
    final query = '''SELECT COUNT(*) as total
      FROM bovines
      INNER JOIN bovines_output ON bovines_output.bovine_id = bovines.id;''';
    final result = await connection.rawQuery(query);
    return result.first["total"] as int;
  }

  @override
  Future<List<ResumeGeneric>> totalMoneyAll() async {
    final connection = await DatabaseHelper.getInstance();
    final results = await connection.rawQuery(viewResumeAllMoney);
    print(results);
    return results.map((row) => ResumeGeneric.fromJson(row)).toList();
  }

  @override
  Future<List<ResumeGeneric>> totalMoneyByOwner() async {
    final connection = await DatabaseHelper.getInstance();
    final results = await connection.rawQuery(viewResumeByOwner);
    return results.map((row) => ResumeGeneric.fromJson(row)).toList();
  }
}
