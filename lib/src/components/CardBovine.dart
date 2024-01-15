import 'package:app_ganado_finca/src/components/DetailScreen.dart';
import 'package:app_ganado_finca/src/models/Bovine.dart';
import 'package:app_ganado_finca/src/routes/main.dart';
import 'package:app_ganado_finca/src/shared/utils/calcularTiempoTranscurrido.dart';
import 'package:flutter/material.dart';

class CardBovine extends StatelessWidget {
  final Bovine bovine;
  final int total;
  final int currentItem;

  const CardBovine({
    super.key,
    required this.bovine,
    required this.total,
    required this.currentItem,
  });
  final defaultImage = 'https://th.bing.com/th/id/R.ed7e0b7fcce4172ea922c52582f03422?rik=i0hXxqOVkXoQnA&pid=ImgRaw&r=0';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 2,right: 2),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ListTile(
                leading: SizedBox(
                  width: 50,
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
                  Navigator.pushNamed(context, bovineDetailsRoute, arguments: bovine);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10,6,0,6),
                  child: Text(bovine.name),
                ),
              ),
              trailing: PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'action1', child: Text('Sacar')),
                  const PopupMenuItem(value: 'action2', child: Text('Editar')),
                ],
                onSelected: (value) {
                    //  Navigator.of(context).pushNamed(detailScreen,
                    //       arguments: bovine.photo ?? defaultImage);
                },
              ),
            ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30,0,30,7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(calcularTiempoTranscurrido(
                      bovine.dateBirth, DateTime.now())),
                  Text("$currentItem / $total"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
