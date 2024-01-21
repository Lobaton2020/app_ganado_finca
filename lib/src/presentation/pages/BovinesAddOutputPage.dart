import 'package:app_ganado_finca/src/presentation/components/FormCreateOutputBovine.dart';
import 'package:app_ganado_finca/src/presentation/components/SimpleAppBar.dart';
import 'package:flutter/material.dart';

class BovinesAddOutputPage extends StatelessWidget {
  const BovinesAddOutputPage({super.key});
  @override
  Widget build(BuildContext context) {
    final int bovine_id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: buildSimpleAppBar(context, 'Crear registro de salida'),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: FormCreateOutputBovine(bovine_id: bovine_id),
        ),
      ),
    );
  }
}
