import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/presentation/components/DetailScreen.dart';
import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/presentation/routes/main.dart';
import 'package:app_ganado_finca/src/shared/components/TextBordered.dart';
import 'package:app_ganado_finca/src/shared/config.dart';
import 'package:app_ganado_finca/src/shared/utils/calcularTiempoTranscurrido.dart';
import 'package:app_ganado_finca/src/shared/utils/formatCurrency.dart';
import 'package:flutter/material.dart';
import 'package:app_ganado_finca/src/presentation/components/SimpleAppBar.dart';

class CardBovineDetail extends StatefulWidget {
  final Bovine bovine;
  const CardBovineDetail({super.key, required this.bovine});
  @override
  State<CardBovineDetail> createState() {
    return _CardBovineDetailState();
  }
}

class _CardBovineDetailState extends State<CardBovineDetail> {
  String owner = "loading...";
  String provenance = "loading...";
  String mother = "loading...";
  String getCutName(String name, {max = 22}) {
    if (name.length <= max) {
      return name;
    }
    return "${name.substring(1, max)}...";
  }

  @override
  void initState() {
    super.initState();
    Future.wait([
      bovineService.findOwners(),
      bovineService.findProvenances(),
      bovineService.findBovinesNames(),
    ]).then((values) {
      final defaultMesage = "No tiene";
      setState(() {
        try {
          owner = values[0]
              .where((x) => x.value.contains(widget.bovine.ownerId.toString()))
              .first
              .label;
        } catch (e) {
          owner = defaultMesage;
        }
        try {
          provenance = values[1]
              .where((x) =>
                  x.value.contains(widget.bovine.provenanceId!.toString()))
              .first
              .label;
        } catch (e) {
          provenance = defaultMesage;
        }
        try {
          mother = values[2]
              .where(
                  (x) => x.value.contains(widget.bovine.motherId!.toString()))
              .first
              .label;
        } catch (e) {
          mother = defaultMesage;
        }
      });
    }).catchError((error) {
      print("Error consulta owners or provenances: " + error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tiempo =
        calcularTiempoCompleto(widget.bovine.dateBirth, DateTime.now());
    return Scaffold(
      appBar: buildSimpleAppBar(context, 'Detalle bovino'),
      body: SingleChildScrollView(
        child: Container(
          child: Card(
            margin: EdgeInsets.all(15),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: cachedNetworkImage(
                          widget.bovine.photo ?? defaultImage),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(detailScreen,
                          arguments: widget.bovine.photo ?? defaultImage);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      widget.bovine.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      widget.bovine.adquisitionAmount != null
                          ? formatearMonedaCOP(double.tryParse(
                                  widget.bovine.adquisitionAmount.toString()) ??
                              0.0)
                          : formatearMonedaCOP(0),
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 21),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                            child: Column(
                          children: [
                            TextBordered(
                                text: widget.bovine.isMale == true
                                    ? "Macho"
                                    : "Hembra"),
                            TextBordered(text: "Madre $mother"),
                            TextBordered(text: "Viene de $provenance"),
                          ],
                        )),
                      ),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 2.0,
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                            child: Column(
                          children: [
                            TextBordered(text: "Color ${widget.bovine.color}"),
                            TextBordered(
                                text: calcularTiempoCompleto(
                                    widget.bovine.dateBirth, DateTime.now())),
                            TextBordered(
                                text: widget.bovine.forIncrease
                                    ? "Al aumento"
                                    : "Propia"),
                            TextBordered(text: "Dueño: $owner"),
                          ],
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
