import 'package:app_ganado_finca/src/components/FormCreateBovine.dart';
import 'package:app_ganado_finca/src/components/SimpleAppBar.dart';
import 'package:flutter/material.dart';

class BovineAddPage extends StatelessWidget{
  const BovineAddPage({super.key});
  void handleSubmitted(dynamic data) {
    print(data);
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: buildSimpleAppBar(context, 'Crear registro'),
      body: Container(
        margin: EdgeInsets.all(10),
        child: FormCreateBovine(),
      ),
    );
  }
}