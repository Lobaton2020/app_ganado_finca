import 'package:app_ganado_finca/src/shared/models/IOptions.dart';

abstract class ResumeRepository {
  Future<int> totalMachos();
  Future<int> totalHembras();
  Future<List<IOption>> totalGroupedByOwner();
  Future<int> totalSalidas();
}
