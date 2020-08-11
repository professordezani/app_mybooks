import 'package:flutter/material.dart';

Widget appBar(Widget body, String title,
    {BuildContext cotext, FloatingActionButton floatingActionButton}) {
  return Scaffold(
    appBar: AppBar(title: Title(color: Colors.white, child: Text(title))),
    body: Container(padding: EdgeInsets.symmetric(horizontal: 8), child: body),
    floatingActionButton: floatingActionButton,
  );
}
