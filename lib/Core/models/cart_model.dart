class CartItem {
  final String cartId;
  final String productId;
  final Map<String, dynamic> productData;
  int quantity;
  final String userId;

  CartItem({
    required this.cartId,
    required this.productId,
    required this.productData,
    required this.quantity,
    required this.userId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['id'] ?? '', 
      productId: json['productId'] ?? '',
      productData: Map<String, dynamic>.from(json['productData'] ?? {}),
      quantity: json['quantity'] ?? 0,
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': cartId,
      'productId': productId,
      'productData': productData,
      'quantity': quantity,
      'userId': userId,
    };
  }
}
