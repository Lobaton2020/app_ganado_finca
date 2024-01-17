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
  Future<List<Bovine>> listBovines = bovineService.findAll();
  @override
  void initState() {
    super.initState();

    tabObserver.stream.listen((event) {
      print("Event" + event.toString());
      if (AppTabs.bovines.index == event) {
        setState(() {
          listBovines = bovineService.findAll();
        });
      }
    });

     internetState.listen((value) {
      if (value == InternetState.connected) {
        print("RELOADING STATE, CONNECTED #######################");
        setState(() {
          listBovines = bovineService.findAll();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bovine>>(
        future: listBovines,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bovines = snapshot.data!;
          return Scaffold(
            body: ListView.builder(
              itemCount: bovines.length,
              itemBuilder: ((context, index) {
                return CardBovine(
                    bovine: bovines[index],
                    total: bovines.length,
                    currentItem: index + 1);
              }),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, bovineAddRoute);
              },
              tooltip: 'Añadir bovino',
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}