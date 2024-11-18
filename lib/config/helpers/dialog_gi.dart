import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDialog {
  static void showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    bool isDismissible = true,
    Color barrierColor = Colors.black54,
    String textActionOk = "Aceptar",
    String textActionCancel = "Cancelar",
    VoidCallback? actionOk,
    VoidCallback? actionCancel,
    ButtonStyleButton? btnOk,
    ButtonStyleButton? btnCancel,
    bool hasCancelBtn = true,
  }) {
    dismissDialog() => context.pop();
    // dismissDialog()=> Navigator.of(context, rootNavigator: true).pop();
    actionOk ??= dismissDialog;
    actionCancel ??= dismissDialog;
    // actionOk = actionOk == null ? dismissDialog : () {
    //   actionOk!();
    //   // Future.delayed(const Duration(milliseconds: 300), () => actionOk!());
    //   // dismissDialog();
    // };
    // actionCancel = actionCancel == null ? dismissDialog : () {
    //   dismissDialog();
    //   actionCancel!();
    // };
    btnOk ??= FilledButton(onPressed: actionOk, child: Text(textActionOk));
    btnCancel ??=
        TextButton(onPressed: actionCancel, child: Text(textActionCancel));
    showDialog(
        useRootNavigator: true,
        context: context,
        barrierColor: barrierColor,
        barrierDismissible: isDismissible,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [if (hasCancelBtn) btnCancel!, btnOk!],
            ));
  }
}
