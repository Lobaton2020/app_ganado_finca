import 'package:flutter/material.dart';

AppBar buildSimpleAppBar(BuildContext context, title) {
  return AppBar(
    backgroundColor: Colors.lightGreen,
    leading: BackButton(onPressed: () => Navigator.pop(context)),
    title: Text(title),
  );
}
