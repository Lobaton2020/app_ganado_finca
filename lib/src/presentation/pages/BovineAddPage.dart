import 'package:app_ganado_finca/src/presentation/components/FormCreateBovine.dart';
import 'package:app_ganado_finca/src/presentation/components/SimpleAppBar.dart';
import 'package:flutter/material.dart';

class BovineAddPage extends StatelessWidget {
  const BovineAddPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSimpleAppBar(context, 'Crear registro'),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: FormCreateBovine(),
        ),
      ),
    );
  }
}
