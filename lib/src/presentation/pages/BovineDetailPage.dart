import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/presentation/components/CardBovineDetail.dart';
import 'package:flutter/material.dart';
class BovineDetailPage extends StatefulWidget {
  const BovineDetailPage({super.key});

  @override
  State<BovineDetailPage> createState() => _BovineDetailPage();
}

class _BovineDetailPage extends State<BovineDetailPage> {
  Bovine? bovine;
  void loadBovine(String name) {
    bovineOutputService
        .findOneByName(name)
        .then((value) => {setState(() => bovine = value)});
  }
  @override
  Widget build(BuildContext context){
    final bovineParam = ModalRoute.of(context)!.settings.arguments as dynamic;
    if (bovineParam.runtimeType.toString() == "String" && bovine == null) {
      loadBovine(bovineParam);
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        color: Colors.white,
      );
    }
    return Container(
      child: CardBovineDetail(
          bovine: bovineParam.runtimeType.toString() == "String"
              ? bovine
              : bovineParam),
    );
  }
}