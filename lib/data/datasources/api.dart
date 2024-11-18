import 'package:prueba_tecnica/data/datasources/usecases/products_mockapi.dart';
import 'package:prueba_tecnica/data/dio/my_dio.dart';
import 'package:prueba_tecnica/domain/repositories/remote/remote_repository.dart';
import 'package:prueba_tecnica/domain/repositories/remote/usecases/products_remote_repository.dart';

class ApiConsumer extends RemoteRepository {
  static final RemoteRepository _instace = ApiConsumer._();
  late MyDio _myDio;
  late ProductsMockapi _productsMockapi;
  static RemoteRepository getInstance() => _instace;

  ApiConsumer._() {
    _myDio = MyDio();
    _productsMockapi = ProductsMockapi(_myDio);
  }

  @override
  ProductsRemoteRepository get productsRepository => _productsMockapi;
}
