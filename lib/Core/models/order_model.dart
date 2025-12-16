import 'package:fast_food_app/Core/models/order_item_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderModel {
  final String? id; 
  final String userId; 
  final List<OrderItem> items;
  final int totalQuantity;
  final int price;
  final LatLng pickupLocation;
  final LatLng deliveryLocation;
  final String pickupAddress;
  final String deliveryAddress;
  final String? createdAt;
  final String? shipperId;
  final String? shipperName;
  final String? shipperPhone;
  String? status;
  final int discountAmount;
  final int shippingFee;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalQuantity,
    required this.price,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.pickupAddress,
    required this.deliveryAddress,
    this.createdAt,
    this.shipperId,
    this.shipperName,
    this.shipperPhone,
    this.status,
    this.discountAmount = 0,
    this.shippingFee = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "items": items.map((e) => e.toJson()).toList(),
      "totalQuantity": totalQuantity,
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
      "discountAmount": discountAmount,
      "shippingFee": shippingFee
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"] ?? json["_id"],
      userId: json["userId"],
      items: (json["items"] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      totalQuantity: json["totalQuantity"],
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
      createdAt: json['createdAt'],
      shipperId: json["shipperId"],
      shipperName: json['shipperInfo'] != null 
          ? json['shipperInfo']['username'] 
          : null,
      shipperPhone: json['shipperInfo'] != null 
          ? json['shipperInfo']['phone_number'] 
          : null,
      status: json["status"],
      discountAmount: json["discountAmount"] ?? 0,
      shippingFee: json["shippingFee"] ?? 0
    );
  }
}
