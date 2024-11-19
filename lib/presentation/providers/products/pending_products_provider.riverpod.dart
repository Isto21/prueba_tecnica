// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prueba_tecnica/config/constants/consts.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/domain/repositories/remote/usecases/products_remote_repository.dart';
import 'package:prueba_tecnica/presentation/providers/data/api_provider.riverpod.dart';
import 'package:prueba_tecnica/presentation/providers/products/reviewed_products_provider.riverpod.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, PendingProductsStatus>((ref) {
  return ProductsNotifier(ref.watch(reviewedproductsProvider.notifier),
      ref.watch(apiProvider).productsRepository);
});

class ProductsNotifier extends StateNotifier<PendingProductsStatus> {
  ProductsRemoteRepository productsRemoteRepository;
  ReviewedProductsNotifier reviewedProductsNotifier;
  int currentPage = 1;
  ProductsNotifier(
    this.reviewedProductsNotifier,
    this.productsRemoteRepository,
  ) : super(PendingProductsStatus()) {
    getPendingProducts();
  }

  Future<void> getPendingProducts() async {
    try {
      if (state.isLoading) return;
      state = state.copyWith(isLoading: true);
      final products = await productsRemoteRepository.getProductsByStatus(
          page: currentPage, limit: ProductLimits.pending, isReviewed: false);
      if (products.length < 9) {
        currentPage = -1;
      }
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorCode: 400);
    }
  }

  Future<bool> acceptOrDeclineproducts(int id, bool isAccepted) async {
    try {
      await productsRemoteRepository.aproveOrDeclineProduct(
          id: id, isApproved: isAccepted);
      reviewedProductsNotifier.addProduct(
        state.products!.firstWhere((element) => element.isarId == id),
      );
      deleteProduct(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  void deleteProduct(int id) {
    state = state.copyWith(
        products: state.products!.where((item) => item.isarId != id).toList());
  }

  void changeStatus(int id) {
    state = state.copyWith(
        products: state.products?.map((product) {
      if (product.isarId == id) {
        final status = (product.status == ProductStatus.pending)
            ? ProductStatus.accepted
            : product.status == ProductStatus.accepted
                ? ProductStatus.declined
                : ProductStatus.pending;
        return product.copyWith(
            status: status,
            isReviewed: status != ProductStatus.pending ? true : false);
      }
      return product;
    }).toList());
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || currentPage == -1) return;
    state = state.copyWith(isLoading: true);
    currentPage += 1;
    final products = await productsRemoteRepository.getProductsByStatus(
        page: currentPage, limit: ProductLimits.pending, isReviewed: false);
    if (products.isNotEmpty) {
      state = state.copyWith(products: [...state.products!, ...products]);
    } else {
      currentPage = -1;
    }
    state = state.copyWith(isLoading: false);
  }
}

class PendingProductsStatus {
  List<Product>? products;
  bool isLoading;
  int? errorCode;
  PendingProductsStatus({
    this.products,
    this.isLoading = false,
    this.errorCode,
  });

  PendingProductsStatus copyWith({
    List<Product>? products,
    bool? isLoading,
    int? errorCode,
  }) {
    return PendingProductsStatus(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
