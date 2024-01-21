import 'package:app_ganado_finca/src/application/domain/models/BovineOutput.dart';
import 'package:app_ganado_finca/src/presentation/components/DetailScreen.dart';
import 'package:app_ganado_finca/src/presentation/routes/main.dart';
import 'package:app_ganado_finca/src/shared/components/TextBordered.dart';
import 'package:app_ganado_finca/src/shared/config.dart';
import 'package:app_ganado_finca/src/shared/utils/calcularTiempoTranscurrido.dart';
import 'package:app_ganado_finca/src/shared/utils/formatCurrency.dart';
import 'package:flutter/material.dart';

class CardBovineOutput extends StatelessWidget {
  final BovineOutput bovine_output;
  final int total;
  final void Function(int) onRemoveBovineOutput;
  const CardBovineOutput({
    super.key,
    required this.bovine_output,
    required this.total,
    required this.onRemoveBovineOutput,
  });

  String getCutName(String name, {max = 16}) {
    if (name.length <= max) {
      return name;
    }
    return "${name.substring(1, max)}..";
  }

  @override
  Widget build(BuildContext context) {
    final description = bovine_output.description ?? '';
    final amount = formatearMonedaCOP(double.parse(
        bovine_output.soldAmount != null
            ? bovine_output.soldAmount.toString()
            : "0"));
    final concatAmountAndDescription = description + '\n' + amount;
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
                        child: cachedNetworkImage(
                            bovine_output.photo ?? defaultImage),
                        onTap: () {
                          Navigator.of(context).pushNamed(detailScreen,
                              arguments: bovine_output.photo ?? defaultImage);
                        },
                      ),
                      // padding: EdgeInsets.only(top: 4, left: 0),
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Text(getCutName(bovine_output.name ?? '')),
                      onTap: () {
                        Navigator.pushNamed(context, bovineDetailsRoute,
                            arguments: bovine_output.name);
                      },
                    ),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: [
                            TextBordered(
                                type: TextBorderedType.small,
                                text: (bovine_output.wasSold
                                        ? "Vendida "
                                        : "Fallecida ") +
                                    (bovine_output.createdAt != null
                                        ? calcularTiempoTranscurrido(
                                            bovine_output.createdAt as DateTime,
                                            DateTime.now())
                                        : 'None')),
                            PopupMenuButton<String>(
                                itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          value: "detail",
                                          child: Text('Ver detalle')),
                                      const PopupMenuItem(
                                          value: "remove",
                                          child: Text('Devolver')),
                                    ],
                                onSelected: (value) {
                                  if (value == "detail") {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(bovine_output.wasSold
                                              ? "Vendida"
                                              : "Fallecida"),
                                          content:
                                              Text(concatAmountAndDescription),
                                          actions: [
                                            TextButton(
                                              child: Text('Cerrar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmación'),
                                        content: Text(
                                            '¿Está seguro de que desea continuar?'
                                            '*Se devolverá a la seccion de Ganado'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Confirmar'),
                                            onPressed: () {
                                              onRemoveBovineOutput(
                                                  bovine_output.id as int);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  Navigator.of(context)
                                      .pushNamed(value, arguments: 2);
                                })
                          ],
                        ),
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
