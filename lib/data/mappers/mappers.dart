import 'package:prueba_tecnica/data/models/product_model.module.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';

class Mappers {
  List<Product> productMapperToEntity(List<ProductModel> productsModel) =>
      productsModel
          .map((productModel) => Product(
                description: productModel.descritpion,
                isarId: productModel.id,
                status: parseProductStatus(productModel.status),
                isReviewed: productModel.isReviewed,
                material: productModel.material,
                price: productModel.price,
                title: productModel.title,
              ))
          .toList();
}
