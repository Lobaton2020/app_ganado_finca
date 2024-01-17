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
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            showSnackBar(context, "Conectado a internet");
            internetState.add(InternetState.connected);
            synchronizeService.synchronizeBovines().then((value) {
              if (value > 0) {
                showSnackBar(
                    context, "Actualizamos $value bovinos en la nube!");
              }
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Finca App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: "Principal",
            ),
            Tab(
              text: "Vacas",
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
