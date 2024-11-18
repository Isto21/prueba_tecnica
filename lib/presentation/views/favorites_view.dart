import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prueba_tecnica/presentation/providers/products/fav_products_provider.riverpod.dart';
import 'package:prueba_tecnica/presentation/widgets/products/products_widget.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/standard_error_page.dart';

List<String> settings = ['Cambiar contraseña', 'Sobre Nosotros', 'Contáctenos'];

final GlobalKey<AnimatedListState> _listKey = GlobalKey();

class SettingsView extends HookConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final favorites = ref.watch(favProvider);
    return Scaffold(
        body: (favorites.isEmpty)
            ? StandardErrorPage(
                height: .3,
                icon: Icons.error,
                firstText: "No hay productos",
                secondText: "Por favor regrese más tarde")
            : AnimatedList(
                key: _listKey,
                initialItemCount: favorites.length,
                itemBuilder: (context, index, animation) {
                  return ProductCard(
                    product: favorites[index],
                    globalKey: _listKey,
                    animation,
                    index: index,
                  );
                },
              ));
  }
}
