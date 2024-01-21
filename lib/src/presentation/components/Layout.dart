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
  StreamSubscription? tabSubscription;
  Future<void> cleanLocalData() async {
    await synchronizeService.removeLocalData();
    showSnackBar(context, 'Proceso hecho con exito');
    tabObserver.add(tabObserver.stream.value);
  }

  String ln(String str) {
    return str.length != 0 ? '\n' : '';
  }

  Future<void> sincronizarInformacion() async {
    if (internetState.stream.value == InternetState.disconnected) {
      showSnackBar(context, 'Debes conectarte a internet');
      return;
    }
    showSnackBar(context, "Sincronizando...");
    var message = "";
    await synchronizeService.synchronizeBovines().then((value) {
      if (value > 0) {
        message += "Actualizamos $value bovinos en la nube";
      }
    }).catchError((err) {
      print("Error1: $err");
      showSnackBar(context, "Error de sincronizacion, data corrupta");
    });
    await synchronizeService.synchronizeOutputs().then((value) {
      if (value > 0) {
        message +=
            "${ln(message)}Actualizamos $value salidas de bovinos en la nube";
      }
    }).catchError((err) {
      print("Error2: $err");
      showSnackBar(context, "Error de sincronizacion, data corrupta");
    });
    await synchronizeService.pullInCaseRemoteChanged().then((value) {
      if (value) {
        message += "${ln(message)}Sincronizamos la base de datos local";
      }
    }).catchError((err) {
      showSnackBar(context, "Fi: $err");
    });
    if (message.length == 0) {
      showSnackBar(context, "Sincronización exitosa");
    } else {
      showSnackBar(context, message);
    }
    tabObserver.add(tabObserver.stream.value);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) async {
        switch (status) {
          case InternetConnectionStatus.connected:
            showSnackBar(context, "Conectado a internet");
            internetState.add(InternetState.connected);
            await Future.delayed(Duration(seconds: 3))
                .then((value) => sincronizarInformacion());
            break;
          case InternetConnectionStatus.disconnected:
            showSnackBar(context, "Se fue el internet");
            print("Internet OFF");
            internetState.add(InternetState.disconnected);
            break;
        }
      },
    );
    tabSubscription = tabObserver.listen((value) {
      _tabController.animateTo(value);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    tabSubscription?.cancel();
  }
  Future<void> sincronizeAction() async {
    try {
      if (internetState.stream.value == InternetState.disconnected) {
        showSnackBar(context, 'Debes conectarte a internet');
        return;
      }
      showSnackBar(context, 'Actualizando base de datos local...');
      await synchronizeService.pullBovinesData();
      await synchronizeService.pullBovinesOutputData();
      showSnackBar(context, 'Actualización exitosa');
      tabObserver.add(tabObserver.stream.value);
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
                case 'pull':
                  await sincronizeAction();
                  break;
                case 'synchronize':
                  await sincronizarInformacion();
                  break;
                case 'clean':
                  await cleanLocalData();
                  break;
                default:
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'synchronize',
                child: Text('Sincronizar'),
              ),
              const PopupMenuItem(
                value: 'pull',
                child: Text('Obtener cambios'),
              ),
              const PopupMenuItem(
                value: 'clean',
                child: Text('Limpiar data local'),
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
