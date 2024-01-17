import 'package:flutter/material.dart';

class BovineDetailPage extends StatelessWidget{
  const BovineDetailPage({super.key});
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Text("BovineDetailPage asds"),
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text("Regresar")
        )
      ],
    );
  }
}