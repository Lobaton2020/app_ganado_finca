import 'package:app_ganado_finca/src/presentation/components/DetailScreen.dart';
import 'package:app_ganado_finca/src/presentation/pages/BovineAddPage.dart';
import 'package:app_ganado_finca/src/presentation/pages/BovineDetailPage.dart';
import 'package:app_ganado_finca/src/presentation/pages/BovinesAddOutputPage.dart';
import 'package:app_ganado_finca/src/presentation/pages/BovinesEditPage.dart';
import 'package:flutter/material.dart';

const bovineAddRoute = "/bovine/add";
const bovineDetailsRoute = "/bovine/details";
const detailScreen = "/image/detail";
const editBovine = "/bovine/edit";
const addBovineOutput = "/bovine//output/add";

final appRoutes = {
  bovineDetailsRoute: (BuildContext context) => BovineDetailPage(),
  bovineAddRoute: (BuildContext context) => BovineAddPage(),
  detailScreen: (BuildContext context) => DetailScreen(),
  editBovine: (BuildContext context) => BovinesEditPage(),
  addBovineOutput: (BuildContext context) => BovinesAddOutputPage(),
};
