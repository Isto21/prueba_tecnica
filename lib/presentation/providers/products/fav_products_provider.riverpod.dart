import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/domain/repositories/local/local_repository.dart';
import 'package:prueba_tecnica/presentation/providers/data/api_provider.riverpod.dart';

final favProvider =
    StateNotifierProvider<FavoritesNotifier, List<Product>>((ref) {
  return FavoritesNotifier(ref.read(localRepositoryProvider));
});

final isFavoriteProvider = FutureProvider.family<bool, int>((ref, id) async {
  return ref.read(localRepositoryProvider).isFavorite(id);
});

class FavoritesNotifier extends StateNotifier<List<Product>> {
  LocalRepository localRepository;
  FavoritesNotifier(this.localRepository) : super([]) {
    getFavorites();
  }
  Future<void> getFavorites() async {
    try {
      if (state.isEmpty) {
        state = await localRepository.getReviewProducts();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFav(Product product) async {
    try {
      await localRepository.toggleFavorite(product);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      await localRepository.deleteProduct(productId);
      await getFavorites();
    } catch (e) {
      rethrow;
    }
  }
}
