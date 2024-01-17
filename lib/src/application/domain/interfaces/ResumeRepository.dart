import 'package:app_ganado_finca/src/shared/models/IOptions.dart';

abstract class ResumeRepository {
  Future<List<int>> totalMachos();
  Future<List<int>> totalHembras();
  Future<List<IOption>> totalGroupedByOwner();
}
