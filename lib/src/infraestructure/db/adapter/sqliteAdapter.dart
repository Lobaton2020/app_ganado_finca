import 'dart:io';
import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/infraestructure/db/queries/ddlDb.dart';
import 'package:app_ganado_finca/src/infraestructure/db/queries/dmlDb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Agrega esta línea para importar la función 'join'

final configDB = {
  "name": "app_ganado_finca.db",
  "version": 1,
};

void onCreateLocalDB(Database db, int version) async {
  await db.execute(ddlTableOwners);
  await db.execute(ddlTableProvenances);
  await db.execute(ddlTableBovines);
  await db.execute(ddlTableBovinesOutput);
  // Default inserts
  await db.execute(dmlTableProvenance);
  await db.execute(dmlTableOwners);
  await synchronizeService.pullBovinesData();
  await synchronizeService.pullBovinesData();
}

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getInstance() async {
    if (_database == null) {
      String pathDb = await getDatabasesPath();
      String path = join(pathDb, configDB["name"] as String);
      _database = await openDatabase(
        path,
        version: configDB["version"] as int,
        onCreate: onCreateLocalDB,
      );
    }
    return _database!;
  }
}

