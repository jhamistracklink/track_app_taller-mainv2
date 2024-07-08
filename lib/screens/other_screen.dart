import 'package:flutter/material.dart';

class OtherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OtherScreen();
  }
}

class _OtherScreen extends State<OtherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Otros'),
      ),
    );
  }
}