// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:prueba_tecnica/config/constants/consts.dart';
import 'package:prueba_tecnica/data/dio/my_dio.dart';
import 'package:prueba_tecnica/data/mappers/mappers.dart';
import 'package:prueba_tecnica/data/models/product_model.module.dart';
import 'package:prueba_tecnica/domain/entities/product.dart';
import 'package:prueba_tecnica/domain/repositories/remote/usecases/products_remote_repository.dart';

class ProductsMockapi extends ProductsRemoteRepository {
  final MyDio _myDio;
  final String _path = "todo/product";
  ProductsMockapi(
    this._myDio,
  );

  @override
  Future<void> aproveOrDeclineProduct(
      {required int id, required bool isApproved}) async {
    try {
      await _myDio
          .request(requestType: RequestType.PUT, path: "$_path/$id", data: {
        "status": isApproved
            ? ProductStatusConsts.accepted
            : ProductStatusConsts.declined,
        "isReviewed": true
      });
    } on CustomDioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await _myDio.request(
        requestType: RequestType.DELETE,
        path: "$_path/$id",
      );
    } on CustomDioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByStatus(
      {required int page, required int limit, required bool isReviewed}) async {
    try {
      final response = await _myDio
          .request(requestType: RequestType.GET, path: _path, queryParameters: {
        "page": page,
        "limit": limit,
        "isReviewed": isReviewed,
      });
      final List<ProductModel> productModels = List<ProductModel>.from(
        (response).map<ProductModel>(
          (x) => ProductModel.fromMap(x as Map<String, dynamic>),
        ),
      );
      final List<Product> products =
          Mappers().productMapperToEntity(productModels);
      return products;
    } on CustomDioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getReviewProducts() {
    // TODO: implement getReviewProducts
    throw UnimplementedError();
  }
}
