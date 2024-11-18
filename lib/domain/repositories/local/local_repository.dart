import 'package:prueba_tecnica/domain/entities/product.dart';

abstract class LocalRepository {
  Future<bool> isFavorite(int productId);
  Future<void> toggleFavorite(Product product);
  Future<List<Product>> getReviewProducts();
  Future<bool> deleteProduct(int productId);
}
