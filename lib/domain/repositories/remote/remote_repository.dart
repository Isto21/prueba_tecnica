import 'package:prueba_tecnica/domain/repositories/remote/usecases/products_remote_repository.dart';

abstract class RemoteRepository {
  ProductsRemoteRepository get productsRepository;
}
