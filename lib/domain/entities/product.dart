// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:isar/isar.dart';
import 'package:prueba_tecnica/config/constants/consts.dart';

part 'product.g.dart';

enum ProductStatus { accepted, declined, pending }

ProductStatus parseProductStatus(int status) {
  switch (status) {
    case ProductStatusConsts.pending:
      return ProductStatus.pending;
    case ProductStatusConsts.accepted:
      return ProductStatus.accepted;
    case ProductStatusConsts.declined:
      return ProductStatus.declined;
    default:
      return ProductStatus.pending;
  }
}

bool? isChecked(ProductStatus status) {
  switch (status) {
    case ProductStatus.accepted:
      return true;
    case ProductStatus.declined:
      return null;
    case ProductStatus.pending:
      return false;
    default:
      return false;
  }
}

String statusToString(ProductStatus status) {
  switch (status) {
    case ProductStatus.accepted:
      return "Aceptado";
    case ProductStatus.declined:
      return "Rechazado";
    case ProductStatus.pending:
      return "Pendiente";
    default:
      return "Pendiente";
  }
}

@collection
class Product {
  Id isarId = Isar.autoIncrement;
  int id;
  String title;
  String description;
  String price;
  bool isReviewed;
  @Enumerated(EnumType.ordinal)
  ProductStatus status;
  String material;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.isReviewed,
    required this.material,
  });

  Product copyWith({
    int? id,
    String? title,
    String? descritpion,
    String? price,
    ProductStatus? status,
    bool? isReviewed,
    String? material,
  }) {
    return Product(
      status: status ?? this.status,
      id: id ?? this.id,
      title: title ?? this.title,
      description: descritpion ?? description,
      price: price ?? this.price,
      isReviewed: isReviewed ?? this.isReviewed,
      material: material ?? this.material,
    );
  }
}
