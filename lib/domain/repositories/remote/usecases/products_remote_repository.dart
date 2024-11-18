import 'package:prueba_tecnica/domain/entities/product.dart';

abstract class ProductsRemoteRepository {
  Future<List<Product>> getProductsByStatus(
      {required int page, required int limit, required bool isReviewed});
  Future<void> aproveOrDeclineProduct(
      {required int id, required bool isApproved});
  Future<List<Product>> getReviewProducts();
  Future<void> deleteProduct(int id);
}
