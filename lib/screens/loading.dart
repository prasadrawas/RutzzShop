import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: FractionallySizedBox(
            heightFactor: 0.001,
            widthFactor: 0.2,
            child: LinearProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
