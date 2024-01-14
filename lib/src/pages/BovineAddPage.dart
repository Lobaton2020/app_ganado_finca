import 'package:flutter/material.dart';

class BovineAddPage extends StatelessWidget{
  const BovineAddPage({super.key});
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Text("Add a"),
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