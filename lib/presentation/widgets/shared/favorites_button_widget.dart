import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/presentation/providers/products/fav_products_provider.riverpod.dart';

class FavoritesButton extends ConsumerWidget {
  const FavoritesButton(
      {required this.isFav, required this.product, super.key});
  final AsyncValue isFav;
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          await ref.read(favProvider.notifier).toggleFav(product);
          ref.invalidate(favProvider);
          ref.invalidate(isFavoriteProvider(product.isarId));
        },
        icon: (isFav.when(
            data: (data) {
              return (!data)
                  ? const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 25,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 25,
                    );
            },
            error: (w, o) => const Text('Error'),
            loading: () => SizedBox(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator()))));
  }
}
