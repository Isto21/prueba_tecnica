import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_tecnica/config/helpers/snackbar_gi.dart';
import 'package:prueba_tecnica/config/helpers/utils.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/presentation/providers/products/pending_products_provider.riverpod.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/custom_shimmer_effect.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/standard_error_page.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels + 600 >=
          _scrollController.position.maxScrollExtent) {
        ref.read(productsProvider.notifier).loadNextPage();
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
    final productsP = ref.watch(productsProvider);
    return Scaffold(
        body: (productsP.isLoading && productsP.products == null)
            ? CustomShimmerEffect(
                listTilesCount: 10,
                height: 200,
              )
            : (productsP.errorCode == 400)
                ? Center(
                    child: StandardErrorPage(
                        action: () => Future.delayed(
                              Duration(
                                seconds: 3,
                              ),
                              () => ref.invalidate(productsProvider),
                            ),
                        height: .05,
                        icon: Icons.error,
                        firstText: "Error al cargar los productos",
                        secondText: "Espere un momento..."))
                : (productsP.products!.isEmpty)
                    ? StandardErrorPage(
                        height: .3,
                        icon: Icons.error,
                        firstText: "No hay productos",
                        secondText: "Por favor regrese más tarde")
                    : AnimatedList(
                        key: _listKey,
                        controller: _scrollController,
                        initialItemCount: productsP.products!.length + 2,
                        itemBuilder: (context, index, animation) {
                          if (index + 1 > productsP.products!.length) {
                            return (ref
                                        .read(productsProvider.notifier)
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
    final productsP = ref.watch(productsProvider);
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AutoSizeText(
                minFontSize: 1,
                maxLines: 1,
                productsP.products![index].title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: 4,
              ),
              AutoSizeText(
                minFontSize: 1,
                productsP.products![index].description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey),
              ),
              CheckboxListTile.adaptive(
                contentPadding: EdgeInsets.all(0),
                // checkColor: Theme.of(context).primaryColor,
                secondary:
                    (productsP.products![index].status == ProductStatus.pending)
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilledButton.tonal(
                              child: Text(
                                "Aceptar",
                              ),
                              onPressed: () async {
                                loading(context: context);
                                final bool editProduct = await ref
                                    .read(productsProvider.notifier)
                                    .acceptOrDeclineproducts(
                                        productsP.products![index].isarId,
                                        productsP.products![index].status ==
                                                ProductStatus.accepted
                                            ? true
                                            : false);
                                if (editProduct) {
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
                                      text: "Producto editado con éxito");
                                } else {
                                  context.pop();
                                  CustomSnackbar.show(context,
                                      text: "Error al editar producto");
                                }
                              },
                            ),
                          ),
                controlAffinity: ListTileControlAffinity.leading,
                tristate: true,
                value: isChecked(productsP.products![index].status),
                title: AutoSizeText(
                    maxLines: 1,
                    minFontSize: 1,
                    style: Theme.of(context).textTheme.bodyMedium,
                    statusToString(productsP.products![index].status)),
                onChanged: (value) =>
                    ref.read(productsProvider.notifier).changeStatus(
                          productsP.products![index].isarId,
                        ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: AutoSizeText(
                      productsP.products![index].material,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  AutoSizeText(
                    "\$${productsP.products![index].price} USD",
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
    );
  }
}
