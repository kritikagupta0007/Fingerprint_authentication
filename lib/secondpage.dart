import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        title: Text(
          "Home Page",
          style: TextStyle(fontSize: 30),
        ),
        toolbarHeight: 80,
      ),
      body: Center(
        child: Text(
          "Congratulation it works!",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
