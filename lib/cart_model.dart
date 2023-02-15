class Cart {
  late final int? id;
  final String? productId;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;

  Cart(
      {required this.id,
        required this.productId,
        required this.productName,
        required this.initialPrice,
        required this.productPrice,
        required this.quantity,
        required this.unitTag,
        required this.image});

  Cart.fromMap(
      Map<dynamic, dynamic> map,
      )   : id = map['id'],
        productId = map['productId'],
        productName = map['productName'],
        initialPrice = map['initialPrice'],
        productPrice = map['productPrice'],
        quantity = map['quantity'],
        unitTag = map['unitTag'],
        image = map['image'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity,
      'unitTag': unitTag,
      'image': image,
    };
  }
}
