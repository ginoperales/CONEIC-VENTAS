import 'package:coneic_ventas/CONTEO/preventa.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CONEIC VENTAS',
      home: JsonDataWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
