import 'dart:async';

import 'package:app_ganado_finca/src/application/services/getDaoInstanceDependsNetwork.dart';
import 'package:app_ganado_finca/src/shared/utils/rxjs.dart';
import 'package:app_ganado_finca/src/shared/utils/snackBartMessage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:app_ganado_finca/src/presentation/pages/BovinesOutputPage.dart';
import 'package:app_ganado_finca/src/presentation/pages/BovinesPage.dart';
import 'package:app_ganado_finca/src/presentation/pages/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TabBarApp extends StatefulWidget {
  const TabBarApp({super.key});

  @override
  State<TabBarApp> createState() => _TabBarAppState();
}

class _TabBarAppState extends State<TabBarApp> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) async {
        switch (status) {
          case InternetConnectionStatus.connected:
            showSnackBar(
                context, "Conectado a internet, revisando sincronizacion..");
            internetState.add(InternetState.connected);

            await synchronizeService.synchronizeBovines().then((value) {
              if (value > 0) {
                showSnackBar(
                    context, "Actualizamos $value bovinos en la nube!");
              }
            }).catchError((err) {
              print("Error1: $err");
              showSnackBar(context, "Error de sincronizacion, data corrupta!");
            });
            await synchronizeService.synchronizeOutputs().then((value) {
              if (value > 0) {
                showSnackBar(context,
                    "Actualizamos $value salidas de bovinos en la nube!");
              }
            }).catchError((err) {
              print("Error2: $err");
              showSnackBar(context, "Error de sincronizacion, data corrupta!");
            });
            break;
          case InternetConnectionStatus.disconnected:
            showSnackBar(context, "Se fue el internet");
            print("Internet OFF");
            internetState.add(InternetState.disconnected);
            break;
        }
      },
    );
    tabObserver.listen((value) {
      _tabController.animateTo(value);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Future<void> sincronizeAction() async {
    try {
      showSnackBar(context, 'Sincronizando...');
      await synchronizeService.pullBovinesData();
      await synchronizeService.pullBovinesOutputData();
      showSnackBar(context, 'Sincronizado exitoso!');
    } catch (err) {
      showSnackBar(context, "Err: $err");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'Synchrozine':
                  await sincronizeAction();
                  break;
                default:
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Synchrozine',
                child: Text('Reset data local'),
              ),
            ],
            icon: const Icon(Icons.person),
          ),
        ],
        title: const Text('Finca App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: "Resumen",
            ),
            Tab(
              text: "Ganado",
            ),
            Tab(
              text: "Salidas",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: MainPage(),
          ),
          Center(
            child: BovinesPage(),
          ),
          Center(
            child: BovinesOutputPage(),
          ),
        ],
      ),

    );
  }
}
