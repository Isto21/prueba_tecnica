import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class StandardErrorPage extends StatelessWidget {
  final IconData icon;
  final String firstText;
  final String secondText;
  final double height;
  final VoidCallback? action;
  const StandardErrorPage({
    super.key,
    required this.icon,
    required this.firstText,
    required this.secondText,
    this.action,
    this.height = 0.3,
  });
  @override
  Widget build(BuildContext context) {
    if (action != null) {
      action!();
    }
    return FadeInUp(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * height,
              ),
              Icon(
                icon,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                firstText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                secondText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
