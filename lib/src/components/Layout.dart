import 'package:app_ganado_finca/src/pages/BovinesOutputPage.dart';
import 'package:app_ganado_finca/src/pages/BovinesPage.dart';
import 'package:app_ganado_finca/src/pages/MainPage.dart';
import 'package:flutter/material.dart';

class TabBarApp extends StatefulWidget {
  const TabBarApp({super.key});

  @override
  State<TabBarApp> createState() => _TabBarAppState();
}

class _TabBarAppState extends State<TabBarApp>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            // child: MainPage(),
            child: BovinesPage(),
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
