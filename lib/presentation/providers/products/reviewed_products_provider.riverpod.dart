// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prueba_tecnica/config/constants/consts.dart';
import 'package:prueba_tecnica/data/dio/my_dio.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/domain/repositories/remote/usecases/products_remote_repository.dart';
import 'package:prueba_tecnica/presentation/providers/data/api_provider.riverpod.dart';

final reviewedproductsProvider =
    StateNotifierProvider<ReviewedProductsNotifier, ReviewedProductsStatus>(
        (ref) {
  return ReviewedProductsNotifier(ref.read(apiProvider).productsRepository);
});

class ReviewedProductsNotifier extends StateNotifier<ReviewedProductsStatus> {
  ProductsRemoteRepository productsRemoteRepository;
  int currentPage = 1;
  ReviewedProductsNotifier(
    this.productsRemoteRepository,
  ) : super(ReviewedProductsStatus()) {
    getReviewProducts();
  }
  Future<void> getReviewProducts() async {
    try {
      if (state.isLoading) return;
      state = state.copyWith(isLoading: true);
      final products = await productsRemoteRepository.getProductsByStatus(
        isReviewed: true,
        page: currentPage,
        limit: ProductLimits.review,
      );
      if (products.length < 7) {
        currentPage = -1;
      }
      state = state.copyWith(products: products, isLoading: false);
    } on CustomDioError catch (e) {
      state = state.copyWith(isLoading: false, errorCode: e.code);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorCode: 400);
    }
  }

  void addProduct(Product product) {
    try {
      if (state.products != null && state.products!.isNotEmpty) {
        state = state.copyWith(
          products: [...state.products!, product],
        );
      } else {
        state = state.copyWith(products: [product], errorCode: 200);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await productsRemoteRepository.deleteProduct(id);
      state = state.copyWith(
          products:
              state.products!.where((item) => item.isarId != id).toList());
      if (state.products!.isEmpty) {
        state = state.copyWith(errorCode: 404);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || currentPage == -1) return;
    state = state.copyWith(isLoading: true);
    currentPage += 1;
    final products = await productsRemoteRepository.getProductsByStatus(
        page: currentPage, limit: ProductLimits.review, isReviewed: true);
    if (products.isNotEmpty) {
      state = state.copyWith(products: [...state.products!, ...products]);
    } else {
      currentPage = -1;
    }
    state = state.copyWith(isLoading: false);
  }
}

class ReviewedProductsStatus {
  List<Product>? products;
  bool isLoading;
  int? errorCode;
  ReviewedProductsStatus({
    this.products,
    this.isLoading = false,
    this.errorCode,
  });

  ReviewedProductsStatus copyWith({
    List<Product>? products,
    bool? isLoading,
    int? errorCode,
  }) {
    return ReviewedProductsStatus(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
