import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prueba_tecnica/config/helpers/snackbar_gi.dart';
import 'package:prueba_tecnica/config/helpers/utils.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/presentation/providers/products/fav_products_provider.riverpod.dart';
import 'package:prueba_tecnica/presentation/providers/products/reviewed_products_provider.riverpod.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/favorites_button_widget.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard(
    this.animation, {
    super.key,
    required this.product,
    required this.globalKey,
    required this.index,
  });

  final GlobalKey<AnimatedListState> globalKey;
  final int index;
  final Animation<double> animation;
  final Product product;
  @override
  Widget build(BuildContext context, ref) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () async {
              showTransitionDialogue(
                  widget: SimpleDialog(
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            product.title,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    children: [
                      Text(
                        product.description,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade800,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              product.material,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Text(
                            "\$${product.price} USD",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                  context: context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          (product.status == ProductStatus.accepted)
                              ? Icons.check_circle
                              : Icons.do_not_disturb_on,
                          color: (product.status == ProductStatus.accepted)
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          flex: 3,
                          child: AutoSizeText(
                            minFontSize: 1,
                            maxLines: 1,
                            product.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () async {
                              loading(context: context);
                              try {
                                await ref
                                    .read(reviewedproductsProvider.notifier)
                                    .deleteProduct(product.isarId);
                                await ref
                                    .read(favProvider.notifier)
                                    .deleteProduct(product.isarId);
                                ref.invalidate(favProvider);
                                globalKey.currentState?.removeItem(
                                    index,
                                    (context, animation) => ProductCard(
                                        globalKey: globalKey,
                                        animation,
                                        index: index,
                                        product: product),
                                    duration: Duration(milliseconds: 600));
                                context.pop();
                                CustomSnackbar.show(context,
                                    text: "Producto eliminado con éxito");
                              } catch (_) {
                                context.pop();
                                CustomSnackbar.show(context,
                                    text: "Error al eliminar producto");
                              }
                            },
                            icon: Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            )),
                        FavoritesButton(
                            isFav:
                                ref.watch(isFavoriteProvider(product.isarId)),
                            product: product)
                      ],
                    ),
                    AutoSizeText(
                      minFontSize: 1,
                      product.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: AutoSizeText(
                            product.material,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        AutoSizeText(
                          "\$${product.price} USD",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}