import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:fast_food_app/Service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  final String googleApiKey = "AIzaSyB2u3cpI35ia33ISTqyIe2VARoNu1_0ltY";

  Set<Polyline> polylines = {};

  late LatLng shopLocation;
  late LatLng userLocation;
  LatLng driverLocation = const LatLng(0, 0);
  double driverHeading = 0.0;
  
  Set<Marker> markers = {};
  BitmapDescriptor? driverIcon;
  GoogleMapController? mapController;

  void init(OrderModel order) {
    shopLocation = order.pickupLocation;
    userLocation = order.deliveryLocation;
    driverLocation = shopLocation;

    _loadDriverMarker();
    _updateMarkers();
    _setupSocket(order.id ?? '');

    _getRoutePolyline();
  }

  Future<void> _getRoutePolyline() async {
    List<LatLng> routePoints = [
      shopLocation, 
      LatLng(10.800469, 106.660839),
      LatLng(10.800216, 106.660818),
      LatLng(10.799521, 106.660013),
      LatLng(10.798783, 106.659294),
      LatLng(10.797476, 106.657889),
      LatLng(10.796220, 106.656432),
      userLocation,
    ];

    Polyline routeLine = Polyline(
      polylineId: const PolylineId("static_route"),
      points: routePoints,
      color: Colors.blue,
      width: 5,
      jointType: JointType.round,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    polylines = {routeLine};
    notifyListeners();
  }

  Future<void> _loadDriverMarker() async {
    try {
      driverIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'assets/images/shipper_icon.png'
      );
      _updateMarkers(); // Vẽ lại khi có icon
    } catch (e) {
      print("Lỗi icon: $e");
    }
  }

  void _setupSocket(String orderId) {
    _socketService.initSocket();
    
    Future.delayed(const Duration(seconds: 1), () {
      _socketService.joinOrderRoom(orderId);
    });

    _socketService.onDriverLocationUpdate((data) {
      print("Provider received: $data");
      
      double lat = double.parse(data['lat'].toString());
      double lng = double.parse(data['lng'].toString());
      driverHeading = double.parse((data['heading'] ?? 0.0).toString());
      
      driverLocation = LatLng(lat, lng);
      
      _updateMarkers();
      _animateCamera();
      
      notifyListeners();
    });
  }

  void _updateMarkers() {
    markers = {
      Marker(
        markerId: const MarkerId("shop"),
        position: shopLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: const MarkerId("user"),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId("driver"),
        position: driverLocation,
        rotation: driverHeading,
        icon: driverIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        anchor: const Offset(0.5, 0.5),
        zIndex: 2,
      ),
    };
    notifyListeners();
  }
  
  // Hàm set controller từ UI truyền vào
  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void _animateCamera() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: driverLocation, zoom: 16, bearing: driverHeading),
      ),
    );
  }
  
  // Hàm này để nút bấm ở UI gọi
  void findDriver() {
    _animateCamera();
  }

  @override
  void dispose() {
    _socketService.off('delivery_location_update');
    super.dispose();
  }
}