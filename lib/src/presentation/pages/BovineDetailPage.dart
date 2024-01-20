import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/presentation/components/CardBovineDetail.dart';
import 'package:flutter/material.dart';

class BovineDetailPage extends StatelessWidget{
  const BovineDetailPage({super.key});
  @override
  Widget build(BuildContext context){
    final bovine = ModalRoute.of(context)!.settings.arguments as Bovine;
    return Container(
      child: CardBovineDetail(bovine: bovine),
    );
  }
}