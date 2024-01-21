import 'dart:async';

import 'package:app_ganado_finca/src/application/domain/models/BovineOutput.dart';
import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/presentation/components/CardBovineOutput.dart';
import 'package:app_ganado_finca/src/shared/utils/rxjs.dart';
import 'package:flutter/material.dart';

class BovinesOutputPage extends StatefulWidget {
  const BovinesOutputPage({super.key});

  @override
  State<BovinesOutputPage> createState() => _BovinesOutputPage();
}

class _BovinesOutputPage extends State<BovinesOutputPage> {
  List<BovineOutput> listOutputBovines = [];
  bool loading = false;
  StreamSubscription? tabSubscription;
  StreamSubscription? internetStateSubscription;
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    bovineOutputService.findAll().then((value) {
      setState(() {
        listOutputBovines = value;
        loading = false;
      });
    });
    tabSubscription = tabObserver.stream.listen((event) {
      print("Event" + event.toString());
      if (AppTabs.outputs.index == event) {
        loading = true;
        bovineOutputService.findAll().then((value) {
          setState(() {
            listOutputBovines = value;
            loading = false;
          });
        });
      }
    });

    internetStateSubscription = internetState.listen((value) {
      if (value == InternetState.connected &&
          tabObserver.stream.value == AppTabs.outputs.index) {
        loading = true;
        print("RELOADING STATE OUTPUT, CONNECTED #######################");
        bovineOutputService.findAll().then((value) {
          setState(() {
            loading = false;
            listOutputBovines = value;
          });
        });
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    tabSubscription?.cancel();
    internetStateSubscription?.cancel();
  }
  void onRemoveBovineOutput(int id) {
    loading = true;
    bovineOutputService.remove(id).then((value) {
      setState(() {
        loading = false;
        tabObserver.add(AppTabs.outputs.index);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return CircularProgressIndicator();
    }
    if (listOutputBovines.length == 0) {
      return Center(child: Text("No hay informacion"));
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListTile(
                  title: Text("Ganado sacado"),
                  leading: Icon(Icons.zoom_out),
                  trailing: Text(
                    "${listOutputBovines.length.toString()} salidas en total",
                    style: TextStyle(fontSize: 15),
                  )),
              width: double.infinity,
              height: 50,
            ),
            ...listOutputBovines.map((bovine) => CardBovineOutput(
                onRemoveBovineOutput: onRemoveBovineOutput,
                bovine_output: bovine,
                total: listOutputBovines.length)),
          ],
        ),
      ),
    );
  }
}
