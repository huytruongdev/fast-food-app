import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:fast_food_app/service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  
  Set<Polyline> polylines = {};

  late LatLng shopLocation;
  late LatLng userLocation;
  LatLng driverLocation = const LatLng(0, 0);
  double driverHeading = 0.0;

  String? currentStatus;
  
  String pickupName = "Cửa hàng";
  String deliveryName = "Địa chỉ nhận hàng";

  Set<Marker> markers = {};
  BitmapDescriptor? driverIcon;
  GoogleMapController? mapController;

  List<LatLng> _traveledRoute = [];

  void init(OrderModel order) {
    shopLocation = order.pickupLocation;
    userLocation = order.deliveryLocation;
    
    pickupName = order.pickupAddress;
    deliveryName = order.deliveryAddress;

    driverLocation = shopLocation;
    _traveledRoute = [shopLocation];
    currentStatus = order.status;

    _loadDriverMarker();
    _updateMarkers();
    _setupSocket(order.id ?? '');
  }

  Future<void> _loadDriverMarker() async {
    try {
      driverIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'assets/images/shipper_icon.png'
      );
      _updateMarkers();
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
      double lat = double.parse(data['lat'].toString());
      double lng = double.parse(data['lng'].toString());
      driverHeading = double.parse((data['heading'] ?? 0.0).toString());
      
      LatLng newPosition = LatLng(lat, lng);
      driverLocation = newPosition;

      _traveledRoute.add(newPosition);
      
      _updateRealtimePolyline();
      _updateMarkers();
      _animateCamera();
      
      notifyListeners();
    });

    _socketService.getSocket()?.on('order_status_update', (data) {
        if (data['orderId'] == orderId) {
            currentStatus = data['status'];
            notifyListeners();
        }
    });
  }

  void _updateRealtimePolyline() {
    Polyline trailLine = Polyline(
      polylineId: const PolylineId("realtime_trail"),
      points: _traveledRoute,
      color: Colors.blue,
      width: 5,
      jointType: JointType.round,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    polylines = {trailLine};
  }

  void _updateMarkers() {
    markers = {
      Marker(
        markerId: const MarkerId("shop"),
        position: shopLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: pickupName, snippet: "Điểm lấy hàng"),
      ),
      
      Marker(
        markerId: const MarkerId("user"),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: deliveryName, snippet: "Điểm giao hàng"),
      ),
      
      Marker(
        markerId: const MarkerId("driver"),
        position: driverLocation,
        rotation: 0.0,
        icon: driverIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        anchor: const Offset(0.5, 0.5),
        zIndexInt: 2,
        infoWindow: InfoWindow(title: "Tài xế", snippet: currentStatus == 'shipping' ? "Đang di chuyển" : null),
      ),
    };
    notifyListeners();
  }
  
  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void _animateCamera() {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: driverLocation, zoom: 16, bearing: 0.0),
      ),
    );
  }

  void findDriver() {
    _animateCamera();
  }

  @override
  void dispose() {
    _socketService.off('delivery_location_update');
    _socketService.off('order_status_update');
    super.dispose();
  }
}