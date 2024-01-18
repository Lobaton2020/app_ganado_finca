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
  @override
  void initState() {
    super.initState();
    bovineService.findAll().then((value) {
      setState(() {
        listBovines = value;
      });
    });
    tabObserver.stream.listen((event) {
      print("Event" + event.toString());
      if (AppTabs.bovines.index == event) {
        bovineService.findAll().then((value) {
          setState(() {
            listBovines = value;
          });
        });
      }
    });

     internetState.listen((value) {
      if (value == InternetState.connected) {
        print("RELOADING STATE, CONNECTED #######################");
        bovineService.findAll().then((value) {
          setState(() {
            listBovines = value;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return const Center(child: CircularProgressIndicator());
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
            ...listBovines.map((bovine) =>
                CardBovine(bovine: bovine, total: listBovines.length)),
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
