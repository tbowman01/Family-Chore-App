
import 'package:flutter/material.dart';

void main() {
  runApp(FamilyChoresApp());
}

class FamilyChoresApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Chores App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(body: Center(child: Text('Welcome to Family Chores App'))),
    );
  }
}
    