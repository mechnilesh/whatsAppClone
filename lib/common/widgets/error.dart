import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String text;
  const ErrorScreen({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(text);
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }
}
