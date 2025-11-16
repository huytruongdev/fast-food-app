class FoodModel {
  final String productId;
  final String imageCard;
  final String imageDetail;
  final String name;
  final double price;
  final double rate;
  final String specialItems;
  final String categoryId;
  final int kcal;
  final String time;

  FoodModel({
    required this.productId,
    required this.imageCard,
    required this.imageDetail,
    required this.name,
    required this.price,
    required this.rate,
    required this.specialItems,
    required this.categoryId,
    required this.kcal,
    required this.time,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      productId: json["productId"],
      imageCard: json["imageCard"],
      imageDetail: json["imageDetail"],
      name: json["name"],
      price: json["price"].toDouble(),
      rate: json["rate"].toDouble(),
      specialItems: json["specialItems"],
      categoryId: json["categoryId"],
      kcal: json["kcal"] ?? 0,
      time: json["time"] ?? "",
    );
  }
}
