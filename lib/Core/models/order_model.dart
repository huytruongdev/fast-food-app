import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderModel {
  final String? id; 
  final String userId; 
  final String item;
  final int quantity;
  final int price;
  final LatLng pickupLocation;
  final LatLng deliveryLocation;
  final String pickupAddress;
  final String deliveryAddress;

  OrderModel({
    this.id,
    required this.userId,
    required this.item,
    required this.quantity,
    required this.price,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.pickupAddress,
    required this.deliveryAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "item": item,
      "quantity": quantity,
      "price": price,
      "pickupLocation": {
        "lat": pickupLocation.latitude,
        "lng": pickupLocation.longitude,
      },
      "deliveryLocation": {
        "lat": deliveryLocation.latitude,
        "lng": deliveryLocation.longitude,
      },
      "pickupAddress": pickupAddress,
      "deliveryAddress": deliveryAddress,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      userId: json["userId"],
      item: json["item"],
      quantity: json["quantity"],
      price: json["price"],
      pickupLocation: LatLng(
        json["pickupLocation"]["lat"],
        json["pickupLocation"]["lng"],
      ),
      deliveryLocation: LatLng(
        json["deliveryLocation"]["lat"],
        json["deliveryLocation"]["lng"],
      ),
      pickupAddress: json["pickupAddress"],
      deliveryAddress: json["deliveryAddress"],
    );
  }
}
