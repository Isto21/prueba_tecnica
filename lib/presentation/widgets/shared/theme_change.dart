// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ThemeChangeWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const ThemeChangeWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ListTile(
      dense: true,
      title: Text(label),
      leading: Icon(
        icon,
        size: 22,
        // color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onPressed,
    );
  }
}
