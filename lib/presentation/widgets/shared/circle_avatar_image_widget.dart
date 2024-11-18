import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prueba_tecnica/config/helpers/utils.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/custom_alert_dialog.shared.dart';

class CircleAvatarImage extends ConsumerWidget {
  const CircleAvatarImage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final perfilChanger = ref.watch(perfilImageProvider);
    return Stack(children: [
      CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 60,
        child: (perfilChanger != null)
            ? Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Theme.of(context).primaryColor,
                      )
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    width: double.infinity,
                    perfilChanger,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              )
            : const Icon(Icons.person, size: 80),
      ),
      Positioned(
          bottom: 5,
          right: 10,
          child: FloatingActionButton.small(
            onPressed: () {
              selectImage(context, ref);
            },
            child: const Icon(Icons.add_a_photo_outlined),
          ))
    ]);
  }
}

final perfilImageProvider = StateProvider<File?>((ref) {
  return null;
});

Future selectImage(BuildContext context, ref) {
  return showTransitionDialogue(
      context: context,
      barrierDismissible: true,
      widget: CustomAlertDialog(
        title: "Seleccione una fuente de datos para la imagen",
        acceptText: "Camara",
        declineText: "Galeria",
        content: const SizedBox(),
        funcionAccept: () async {
          context.pop();
          final File? image = await SelectImage().takePicture();
          if (image != null) {
            ref.read(perfilImageProvider.notifier).state = image;
          }
        },
        funcionCancel: () async {
          context.pop();
          final File? image = await SelectImage().selectFromGallery();
          if (image != null) {
            ref.read(perfilImageProvider.notifier).state = image;
          }
        },
      ));
}

class SelectImage {
  Future<File?> takePicture() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    return File(image!.path);
  }

  Future<File?> selectFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return File(image!.path);
  }
}
