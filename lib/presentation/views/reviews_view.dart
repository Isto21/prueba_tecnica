import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_tecnica/config/helpers/snackbar_gi.dart';
import 'package:prueba_tecnica/config/helpers/utils.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/presentation/providers/products/fav_products_provider.riverpod.dart';
import 'package:prueba_tecnica/presentation/providers/products/reviewed_products_provider.riverpod.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/custom_shimmer_effect.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/favorites_button_widget.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/standard_error_page.dart';

class ReviewsView extends ConsumerStatefulWidget {
  const ReviewsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends ConsumerState<ReviewsView> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels + 600 >=
          _scrollController.position.maxScrollExtent) {
        ref.read(reviewedproductsProvider.notifier).loadNextPage();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final reviewedProducts = ref.watch(reviewedproductsProvider);
    return Scaffold(
        body: (reviewedProducts.isLoading && reviewedProducts.products == null)
            ? CustomShimmerEffect(
                listTilesCount: 10,
                height: 200,
              )
            : (reviewedProducts.errorCode == 400)
                ? Center(
                    child: StandardErrorPage(
                        action: () => Future.delayed(
                              Duration(
                                seconds: 3,
                              ),
                              () => ref.invalidate(reviewedproductsProvider),
                            ),
                        height: .05,
                        icon: Icons.error,
                        firstText: "Error al cargar los productos revisados",
                        secondText: "Espere un momento..."))
                : (reviewedProducts.errorCode == 404)
                    ? StandardErrorPage(
                        height: .3,
                        icon: Icons.error,
                        firstText: "No hay productos",
                        secondText: "Por favor regrese más tarde")
                    : AnimatedList(
                        key: _listKey,
                        controller: _scrollController,
                        initialItemCount: reviewedProducts.products!.length + 2,
                        itemBuilder: (context, index, animation) {
                          if (index + 1 > reviewedProducts.products!.length) {
                            return (ref
                                        .read(reviewedproductsProvider.notifier)
                                        .currentPage ==
                                    -1)
                                ? const SizedBox()
                                : const CustomShimmerEffect(listTilesCount: 5);
                          }
                          return ProductCard(
                            globalKey: _listKey,
                            animation,
                            index: index,
                          );
                        },
                      ));
  }
}

class ProductCard extends ConsumerWidget {
  const ProductCard(
    this.animation, {
    super.key,
    required this.globalKey,
    required this.index,
  });

  final GlobalKey<AnimatedListState> globalKey;
  final int index;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, ref) {
    final reviewedProducts = ref.watch(reviewedproductsProvider);
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
                    backgroundColor: reviewedProducts.products![index].status ==
                            ProductStatus.accepted
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            reviewedProducts.products![index].title,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    children: [
                      Text(
                        reviewedProducts.products![index].description,
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
                              reviewedProducts.products![index].material,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Text(
                            "\$${reviewedProducts.products![index].price} USD",
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
                          (reviewedProducts.products![index].status ==
                                  ProductStatus.accepted)
                              ? Icons.check_circle
                              : Icons.do_not_disturb_on,
                          color: (reviewedProducts.products![index].status ==
                                  ProductStatus.accepted)
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
                            reviewedProducts.products![index].title,
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
                                    .deleteProduct(
                                        reviewedProducts.products![index].id);
                                globalKey.currentState?.removeItem(
                                    index,
                                    (context, animation) => ProductCard(
                                          globalKey: globalKey,
                                          animation,
                                          index: index,
                                        ),
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
                            isFav: ref.watch(isFavoriteProvider(
                                reviewedProducts.products![index].id)),
                            product: reviewedProducts.products![index])
                      ],
                    ),
                    AutoSizeText(
                      minFontSize: 1,
                      reviewedProducts.products![index].description,
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
                            reviewedProducts.products![index].material,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        AutoSizeText(
                          "\$${reviewedProducts.products![index].price} USD",
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
