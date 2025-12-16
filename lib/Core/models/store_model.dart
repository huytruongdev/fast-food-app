import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreModel {
  final String id;
  final String name;
  final String address;
  final LatLng location;

  StoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
  });
}

final List<StoreModel> storeModelList = [
  StoreModel(
    id: "ST01",
    name: "CN Cầu vượt Cộng Hoà",
    address: "123 Cộng Hòa, Tân Bình, TP.HCM",
    location: const LatLng(10.800669, 106.661126),
  ),
];