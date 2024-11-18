import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String text,
    SnackBarAction? action,
    Duration duration = const Duration(milliseconds: 4000),
  }) {
    if (text.isEmpty) return;
    final snackbar = SnackBar(
      content: Text(text),
      action: action,
      duration: duration,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackbar);
  }
}
