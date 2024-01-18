import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/shared/models/IOptions.dart';
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
  final resume = Map<String, dynamic>();

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
    ]).then((values) {
      setState(() {
        resume["totalHembras"] = values[0];
        resume["totalMachos"] = values[1];
        resume["total"] = (values[0] as int) + (values[1] as int);
        resume["totalSalidas"] = values[2];
        resume["totalGroupedByOwner"] = values[3];
        isLoading = false;
      });
    }).catchError((error) {
      print("Error consulta resumen: $error");
      setState(() {
        isLoading = true;
      });
    });
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
    return Container(
      child: isLoading
          ? CircularProgressIndicator()
          : Column(
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
                    .map((e) => Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 18),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(e.value.toString(),
                                    style: commonTextStyle),
                                width: 30,
                                margin: EdgeInsets.only(left: 60, right: 5),
                              ),
                              Text(e.label, style: commonTextStyle)
                            ],
                          ),
                        )))
                    .toList(),
                Container(
                  child: ListTile(
                      title: Text("Propietarios"),
                      leading: Icon(Icons.analytics)),
                ),
                ...resume["totalGroupedByOwner"]
                    .map((e) => Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 18),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(e.value.toString(),
                                    style: commonTextStyle),
                                width: 30,
                                margin: EdgeInsets.only(left: 60, right: 0),
                              ),
                              Text("de ${e.label}", style: commonTextStyle)
                            ],
                          ),
                        )))
                    .toList(),
              ],
            ),
    );
  }
}
