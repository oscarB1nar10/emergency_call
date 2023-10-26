import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorBanner extends StatelessWidget {
  final String message;

  ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red, // Error color
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
