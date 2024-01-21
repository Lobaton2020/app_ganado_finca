import 'dart:async';
import 'dart:ffi';

import 'package:app_ganado_finca/src/application/domain/models/Bovine.dart';
import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/presentation/components/CardBovine.dart';
import 'package:app_ganado_finca/src/presentation/components/Layout.dart';
import 'package:app_ganado_finca/src/presentation/routes/main.dart';
import 'package:app_ganado_finca/src/shared/utils/rxjs.dart';
import 'package:flutter/material.dart';

class BovinesPage extends StatefulWidget {
  const BovinesPage({super.key});

  @override
  State<BovinesPage> createState() => _BovinesPage();
}

class _BovinesPage extends State<BovinesPage> {
  List<Bovine> listBovines = [];
  bool loading = false;
  StreamSubscription? tabSubscription;
  StreamSubscription? internetStateSubscription;
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    bovineService.findAll().then((value) {
      setState(() {
        listBovines = value;
        loading = false;
      });
    });
    tabSubscription = tabObserver.stream.listen((event) {
      print("Event" + event.toString());
      if (AppTabs.bovines.index == event) {
        loading = true;
        bovineService.findAll().then((value) {
          setState(() {
            listBovines = value;
            loading = false;
          });
        });
      }
    });

    internetStateSubscription = internetState.listen((value) {
      if (value == InternetState.connected &&
          tabObserver.stream.value == AppTabs.bovines.index) {
        loading = true;
        print("RELOADING STATE, CONNECTED #######################");
        bovineService.findAll().then((value) {
          setState(() {
            loading = false;
            listBovines = value;
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
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return CircularProgressIndicator();
    }
    final List<Widget> listRender = listBovines.length == 0
        ? [
            Padding(
              padding: EdgeInsets.only(top: 300),
              child: Center(child: Text("No hay informacion")),
            )
          ]
        : listBovines
            .map((bovine) =>
                CardBovine(bovine: bovine, total: listBovines.length))
            .toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: ListTile(
                  title: Text("Ganado actual"),
                  leading: Icon(Icons.zoom_out),
                  trailing: Text(
                    "${listBovines.length.toString()} animales en total",
                    style: TextStyle(fontSize: 15),
                  )),
              width: double.infinity,
              height: 50,
            ),
            ...listRender
          ],
        ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, bovineAddRoute);
              },
              tooltip: 'Añadir bovino',
              child: const Icon(Icons.add),
            ),
    );
  }
}
