
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String userType; // 'parent' or 'child'

  const HomeScreen({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Text(userType == 'parent'
            ? 'Parent Dashboard'
            : 'Child Dashboard'),
      ),
    );
  }
}
    