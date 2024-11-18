import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/domain/repositories/local/local_repository.dart';

class IsarService extends LocalRepository {
  late Future<Isar> _db;

  IsarService() {
    _db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dr = await getApplicationDocumentsDirectory();
      return await Isar.open([ProductSchema],
          directory: dr.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<List<Product>> getReviewProducts() async {
    final isar = await _db;
    return await isar.products.where().findAll();
  }

  @override
  Future<bool> isFavorite(int productId) async {
    final isar = await _db;
    final Product? fav =
        await isar.products.filter().idEqualTo(productId).findFirst();
    return fav != null;
  }

  @override
  Future<void> toggleFavorite(Product product) async {
    final isar = await _db;
    final favorite =
        await isar.products.filter().idEqualTo(product.id).findFirst();
    if (favorite != null) {
      isar.writeTxnSync(() => isar.products.deleteSync(favorite.isarId));
    } else {
      isar.writeTxnSync(() => isar.products.putSync(product));
    }
  }

  @override
  Future<bool> deleteProduct(int productId) async {
    try {
      final isar = await _db;
      isar.writeTxn(() => isar.products.delete(productId));
      return true;
    } catch (e) {
      return false;
    }
  }
}
