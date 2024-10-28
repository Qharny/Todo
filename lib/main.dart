import 'package:flutter/material.dart';
import 'package:todo/screens/home.dart';

void main() {
  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      // routes: ,
    );
  }
}
