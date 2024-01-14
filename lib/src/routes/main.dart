import 'package:app_ganado_finca/src/components/DetailScreen.dart';
import 'package:app_ganado_finca/src/pages/BovineAddPage.dart';
import 'package:app_ganado_finca/src/pages/BovineDetailPage.dart';
import 'package:flutter/material.dart';

const bovineAddRoute = "/bovine/add";
const bovineDetailsRoute = "/bovine/details";
const detailScreen = "/image/detail";

final appRoutes = {
  bovineDetailsRoute : (BuildContext context) => BovineDetailPage(),
  bovineAddRoute: (BuildContext context) => BovineAddPage(),
  detailScreen: (BuildContext context) => DetailScreen(),
};