import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? acceptText;
  final String? declineText;
  final Widget? content;
  final Color? titleColor;
  final bool centerTitle;
  final void Function()? funcionAccept;
  final void Function()? funcionCancel;
  const CustomAlertDialog(
      {super.key,
      this.titleColor,
      this.centerTitle = false,
      this.title = '',
      this.content,
      this.funcionAccept,
      this.funcionCancel,
      this.acceptText,
      this.declineText});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: (centerTitle)
              ? Center(
                  child: Text(
                    title!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              : Text(
                  title!,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: titleColor),
                ),
          content: content,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            _AcceptButtonDialog(funcionAccept, acceptText),
            _CancelButtonDialog(funcionCancel, declineText),
          ],
        );
      },
    );
  }
}

class _AcceptButtonDialog extends StatelessWidget {
  final void Function()? funcionAccept;
  final String? acceptText;
  const _AcceptButtonDialog(this.funcionAccept, this.acceptText);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Theme.of(context).primaryColor))),
        onPressed: funcionAccept ??
            () {
              context.pop();
              //  Navigator.pop(context);
            },
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Text(acceptText ?? 'Aceptar',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor)),
        ));
  }
}

class _CancelButtonDialog extends StatelessWidget {
  final void Function()? funcionCancel;
  final String? declineText;
  const _CancelButtonDialog(this.funcionCancel, this.declineText);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Theme.of(context).primaryColor))),
        onPressed: funcionCancel ??
            () {
              context.pop();
              //  Navigator.pop(context);
            },
        child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Text(declineText ?? 'Cancelar',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ));
  }
}
