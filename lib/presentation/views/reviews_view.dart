import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica/presentation/providers/products/reviewed_products_provider.riverpod.dart';
import 'package:prueba_tecnica/presentation/widgets/products/products_widget.dart';
import 'package:prueba_tecnica/presentation/widgets/shared/custom_shimmer_effect.dart';
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
                            product: reviewedProducts.products![index],
                            globalKey: _listKey,
                            animation,
                            index: index,
                          );
                        },
                      ));
  }
}
