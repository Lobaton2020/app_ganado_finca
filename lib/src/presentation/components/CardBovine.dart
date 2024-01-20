import 'package:app_ganado_finca/src/presentation/components/DetailScreen.dart';
import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/presentation/routes/main.dart';
import 'package:app_ganado_finca/src/shared/config.dart';
import 'package:app_ganado_finca/src/shared/utils/calcularTiempoTranscurrido.dart';
import 'package:flutter/material.dart';

class CardBovine extends StatelessWidget {
  final Bovine bovine;
  final int total;

  const CardBovine({
    super.key,
    required this.bovine,
    required this.total,
  });

  String getCutName(String name, {max = 22}) {
    if (name.length <= max) {
      return name;
    }
    return "${name.substring(1, max)}...";
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ListTile(
                leading: SizedBox(
                  width: 70,
                  child: Center(
                    child: Container(
                      child: InkWell(
                        child: cachedNetworkImage(bovine.photo ?? defaultImage),
                        onTap: () {
                          Navigator.of(context).pushNamed(detailScreen,
                              arguments: bovine.photo ?? defaultImage);
                        },
                      ),
                      // padding: EdgeInsets.only(top: 4, left: 0),
                    ),
                  ),
                ),
                title: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  onTap: () {
                    Navigator.pushNamed(context, bovineDetailsRoute,
                        arguments: bovine);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getCutName(bovine.name)),
                      Container(
                        child: Row(
                          children: [
                            Text(calcularTiempoTranscurrido(
                                bovine.dateBirth, DateTime.now())),
                            PopupMenuButton<String>(
                                itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          value: editBovine,
                                          child: Text('Editar')),
                                      const PopupMenuItem(
                                          value: addBovineOutput,
                                          child: Text('Sacar')),
                  ],
                  onSelected: (value) {
                                  Navigator.pushNamed(context, addBovineOutput,
                                      arguments: bovine);
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
