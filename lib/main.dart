
import 'package:flutter/material.dart';
import 'package:baatmi/home.dart';
import 'package:baatmi/model.dart';
void main() =>runApp(Myapp());
class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Home(),
    );
  }
}
