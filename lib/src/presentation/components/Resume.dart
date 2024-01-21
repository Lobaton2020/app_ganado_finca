import 'package:app_ganado_finca/src/application/domain/dtos/ResumeGeneric.dart';
import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
import 'package:app_ganado_finca/src/shared/utils/formatCurrency.dart';
import 'package:flutter/material.dart';

class ResumeBovine extends StatefulWidget {
  const ResumeBovine({super.key});
  @override
  ResumeBovineFormState createState() {
    return ResumeBovineFormState();
  }
}

class ResumeBovineFormState extends State<ResumeBovine> {
  bool isLoading = false;
  final resume = Map<String, dynamic>.from({
    "totalMoneyAll": {
      "salida": ResumeGeneric(count: 0, sum: 0, type: ""),
      "actual": ResumeGeneric(count: 0, sum: 0, type: "")
    },
    "totalMoneyByOwner": {"salida": [], "actual": []}
  });

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    super.initState();
    Future.wait([
      resumeRepository.totalHembras(),
      resumeRepository.totalMachos(),
      resumeRepository.totalSalidas(),
      resumeRepository.totalGroupedByOwner(),
      resumeRepository.totalMoneyAll(),
      resumeRepository.totalMoneyByOwner(),
    ]).then((values) {
      setState(() {
        resume["totalHembras"] = values[0];
        resume["totalMachos"] = values[1];
        resume["total"] = (values[0] as int) + (values[1] as int);
        resume["totalSalidas"] = values[2];
        resume["totalGroupedByOwner"] = values[3];
        resume["totalMoneyAll"]["actual"] = (values[4] as List<ResumeGeneric>)
            .where((x) => x.type == "ACTUAL")
            .first;
        resume["totalMoneyAll"]["salida"] = (values[4] as List<ResumeGeneric>)
            .where((x) => x.type == "SALIDA")
            .first;
        resume["totalMoneyByOwner"]["actual"] = (values[5] as List<dynamic>)
            .where((x) => x.type == "ACTUAL")
            .toList();
        resume["totalMoneyByOwner"]["salida"] = (values[5] as List<dynamic>)
            .where((x) => x.type == "SALIDA")
            .toList();
        isLoading = false;
      });
    }).catchError((error) {
      print("Error consulta resumen: $error");
      setState(() {
        isLoading = true;
      });
    });
  }
  Card loadMoneyCard(String label, String value, commonTextStyle) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(label, style: commonTextStyle),
                  Container(
                    child: Text(value, style: commonTextStyle),
                    margin: EdgeInsets.only(left: 60, right: 5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card loadRowCard(String label, String value, commonTextStyle) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(value, style: commonTextStyle),
                width: 30,
                margin: EdgeInsets.only(left: 60, right: 5),
              ),
              Text(label, style: commonTextStyle)
            ],
          ),
        ));
  }

  Card loadMoneyCardCustom(String label, String value, commonTextStyle) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: commonTextStyle),
                  Container(
                    child: Text(value, style: commonTextStyle),
                    margin: EdgeInsets.only(left: 60, right: 5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const commonTextStyle =
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    final cards = [
      IOption(label: "hembras", value: resume["totalHembras"].toString()),
      IOption(label: "machos", value: resume["totalMachos"].toString()),
      IOption(
          label: "salidas de animales",
          value: resume["totalSalidas"].toString())
    ];
    final moneyResume = [
      IOption(
          label:
              "Total avaluacion de ${resume["totalMoneyAll"]["actual"]!.count} animales",
          value: formatearMonedaCOP(resume["totalMoneyAll"]["actual"]!.sum)),
      IOption(
          label:
              "Total salidas de ${resume["totalMoneyAll"]["salida"]!.count} animales",
          value: formatearMonedaCOP(resume["totalMoneyAll"]["salida"]!.sum)),

    ];
    return Container(
      child: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: ListTile(
                        title: Text("Resumen"),
                        leading: Icon(Icons.zoom_out),
                        trailing: Text(
                          "${resume["total"].toString()} animales en total",
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                  ...cards
                      .map((e) => loadRowCard(
                          e.label, e.value.toString(), commonTextStyle))
                      .toList(),
                  Container(
                    child: ListTile(
                        title: Text("Numero animales por propietario"),
                        leading: Icon(Icons.analytics)),
                  ),
                  ...resume["totalGroupedByOwner"]
                      .map((e) => loadRowCard(
                          "de ${e.label}", e.value.toString(), commonTextStyle))
                      .toList(),
                  Container(
                    child: ListTile(
                      title: Text("Resumen monetario"),
                      leading: Icon(Icons.money),
                    ),
                  ),
                  ...moneyResume
                      .map((e) => loadMoneyCard(
                          e.label, e.value.toString(), commonTextStyle))
                      .toList(),
                  Container(
                    child: ListTile(
                      title:
                          Text("Dinero de salidas de ganado por propietario"),
                      leading: Icon(Icons.money),
                    ),
                  ),
                  ...resume["totalMoneyByOwner"]["salida"]
                      .map((e) => loadMoneyCardCustom(
                          e.name, formatearMonedaCOP(e.sum), commonTextStyle))
                      .toList(),
                  Container(
                    child: ListTile(
                      title: Text("Dinero actual total por propietario"),
                      leading: Icon(Icons.money),
                    ),
                  ),
                  ...resume["totalMoneyByOwner"]["actual"]
                      .map((e) => loadMoneyCardCustom(
                          e.name, formatearMonedaCOP(e.sum), commonTextStyle))
                      .toList(),
              ],
            ),
            ),
    );
  }
}
