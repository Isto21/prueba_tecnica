import 'dart:ui';

import 'package:flutter/material.dart';

void loading({required BuildContext context, Widget? child}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => Center(
      child: SizedBox(
          height: 60, width: 60, child: child ?? CircularProgressIndicator()),
    ),
  );
}

Future showTransitionDialogue({
  required Widget widget,
  required BuildContext context,
  bool? barrierDismissible,
}) async {
  final dialog = await showGeneralDialog(
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) => widget,
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
  return dialog;
}
