import 'package:flutter/material.dart';

class SnackbarUtil {
  static void show(
      BuildContext context, {
        required String message,
        required bool success,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
