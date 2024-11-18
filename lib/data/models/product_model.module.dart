import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  int id;
  String title;
  String descritpion;
  String price;
  bool isReviewed;
  int status;
  String material;
  ProductModel({
    required this.id,
    required this.title,
    required this.descritpion,
    required this.price,
    required this.isReviewed,
    required this.status,
    required this.material,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'descritpion': descritpion,
      'price': price,
      'isReviewed': isReviewed,
      'status': status.toString(),
      'material': material,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: int.parse(map['id']),
      title: map['title'] as String,
      descritpion: map['descritpion'] as String,
      price: map['price'] as String,
      isReviewed: map['isReviewed'] as bool,
      status: (map['status'] as int),
      material: map['material'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
