// class FoodModel {
//   final String productId;
//   final String imageCard;
//   final String imageDetail;
//   final String name;
//   final double price;
//   final double rate;
//   final String specialItems;
//   final String categoryId;
//   final int kcal;
//   final String time;
//   final String description;

//   FoodModel({
//     required this.productId,
//     required this.imageCard,
//     required this.imageDetail,
//     required this.name,
//     required this.price,
//     required this.rate,
//     required this.specialItems,
//     required this.categoryId,
//     required this.kcal,
//     required this.time,
//     required this.description,
//   });

//   factory FoodModel.fromJson(Map<String, dynamic> json) {
//     return FoodModel(
//       productId: json["productId"],
//       imageCard: json["imageCard"],
//       imageDetail: json["imageDetail"],
//       name: json["name"],
//       price: json["price"].toDouble(),
//       rate: json["rate"].toDouble(),
//       specialItems: json["specialItems"],
//       categoryId: json["categoryId"],
//       kcal: json["kcal"] ?? 0,
//       time: json["time"] ?? "",
//       description: json["description"] ?? "",
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       "productId": productId,
//       "imageCard": imageCard,
//       "imageDetail": imageDetail,
//       "name": name,
//       "price": price,
//       "rate": rate,
//       "specialItems": specialItems,
//       "categoryId": categoryId,
//       "kcal": kcal,
//       "time": time,
//       "description": description,
//     };
//   }
// }

// class FoodModel {
//   final String productId;
//   final String imageCard;
//   final String imageDetail;
//   final String name;
//   final double price;
//   final double rate;
//   final String specialItems;
//   final String categoryId;
//   final int kcal;
//   final String time;
//   final String description;

//   final double? salePercentage;
//   final DateTime? saleEndTime;

//   FoodModel({
//     required this.productId,
//     required this.imageCard,
//     required this.imageDetail,
//     required this.name,
//     required this.price,
//     required this.rate,
//     required this.specialItems,
//     required this.categoryId,
//     required this.kcal,
//     required this.time,
//     required this.description,
//     this.salePercentage,
//     this.saleEndTime,
//   });

//   double get discountedPrice {
//     if (isSaleActive && salePercentage != null && salePercentage! > 0) {
//       return price * (1 - (salePercentage! / 100.0));
//     }
//     return price;
//   }

//   bool get isSaleActive {
//     if (saleEndTime == null) return false;
//     return saleEndTime!.isAfter(DateTime.now());
//   }

//   factory FoodModel.fromJson(Map<String, dynamic> json) {
//     DateTime? parseSaleEndTime() {
//       if (json["saleEndTime"] == null) return null;
//       if (json["saleEndTime"] is String) {
//         return DateTime.tryParse(json["saleEndTime"]);
//       }
//       if (json["saleEndTime"] is int || json["saleEndTime"] is double) {
//         return DateTime.fromMillisecondsSinceEpoch(
//           (json["saleEndTime"] as num).toInt() * 1000,
//         );
//       }
//       return null;
//     }

//     return FoodModel(
//       productId: json["productId"],
//       imageCard: json["imageCard"],
//       imageDetail: json["imageDetail"],
//       name: json["name"],
//       price: json["price"].toDouble(),
//       rate: json["rate"].toDouble(),
//       specialItems: json["specialItems"],
//       categoryId: json["categoryId"],
//       kcal: json["kcal"] ?? 0,
//       time: json["time"] ?? "",
//       description: json["description"] ?? "",
//       salePercentage: json["salePercentage"]?.toDouble(),
//       saleEndTime: parseSaleEndTime(),
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       "productId": productId,
//       "imageCard": imageCard,
//       "imageDetail": imageDetail,
//       "name": name,
//       "price": price,
//       "rate": rate,
//       "specialItems": specialItems,
//       "categoryId": categoryId,
//       "kcal": kcal,
//       "time": time,
//       "description": description,
//       "salePercentage": salePercentage,
//       "saleEndTime": saleEndTime?.toIso8601String(),
//     };
//   }
// }

class FoodModel {
  final String productId;
  final String imageCard;
  final String imageDetail;
  final String name;
  final double price;
  final double originPrice;
  final double rate;
  final String specialItems;
  final String categoryId;
  final int kcal;
  final String time;
  final String description;

  final double? salePercentage;
  final DateTime? saleEndTime;

  FoodModel({
    required this.productId,
    required this.imageCard,
    required this.imageDetail,
    required this.name,
    required this.price,
    required this.originPrice,
    required this.rate,
    required this.specialItems,
    required this.categoryId,
    required this.kcal,
    required this.time,
    required this.description,
    this.salePercentage,
    this.saleEndTime,
  });

  double get finalPrice {
    return price;
  }

  double get strikedPrice {
    return originPrice;
  }

  bool get isSaleActive {
    if (saleEndTime == null) return false;
    return saleEndTime!.isAfter(DateTime.now());
  }

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseSaleEndTime() {
      if (json["saleEndTime"] == null) return null;
      if (json["saleEndTime"] is String) {
        return DateTime.tryParse(json["saleEndTime"]);
      }
      if (json["saleEndTime"] is int || json["saleEndTime"] is double) {
        return DateTime.fromMillisecondsSinceEpoch(
          (json["saleEndTime"] as num).toInt() * 1000,
        );
      }
      return null;
    }

    return FoodModel(
      productId: json["productId"],
      imageCard: json["imageCard"],
      imageDetail: json["imageDetail"],
      name: json["name"],
      price: json["price"].toDouble(),
      originPrice: json["originPrice"].toDouble(),
      rate: json["rate"].toDouble(),
      specialItems: json["specialItems"],
      categoryId: json["categoryId"],
      kcal: json["kcal"] ?? 0,
      time: json["time"] ?? "",
      description: json["description"] ?? "",
      salePercentage: json["salePercentage"]?.toDouble(),
      saleEndTime: parseSaleEndTime(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "productId": productId,
      "imageCard": imageCard,
      "imageDetail": imageDetail,
      "name": name,
      "price": price,
      "originPrice":
          originPrice, // Nếu bạn đã thêm 'originPrice' vào constructor
      "rate": rate,
      "specialItems": specialItems,
      // ... (các trường khác giữ nguyên)
      "salePercentage": salePercentage,
      "saleEndTime": saleEndTime?.toIso8601String(),
    };
  }
}
