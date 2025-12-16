import 'dart:convert';
import 'dart:async';
import 'package:fast_food_app/Core/Utils/format.dart';
import 'package:fast_food_app/Core/models/order_item_model.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:fast_food_app/Core/providers/cart_provider.dart';
import 'package:fast_food_app/pages/auth/screens/user_activities/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  final String userId;
  const CheckoutScreen({super.key, required this.userId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isPlacingOrder = false;
  LatLng? _userLocation; 
  String _addressText = "Đang lấy vị trí..."; 
  bool _isLoadingLocation = true;
  
  // Phí ship cố định (hoặc bạn có thể tính theo khoảng cách sau này)
  final int _shippingFee = 0; 

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); 
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // street: Số nhà + Tên đường
        // subAdministrativeArea: Quận/Huyện
        // administrativeArea: Tỉnh/Thành phố
        return "${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}";
      }
      return "$lat, $lng"; // Nếu không tìm thấy tên thì trả về toạ độ
    } catch (e) {
      debugPrint("Lỗi Geocoding: $e");
      return "$lat, $lng"; // Fallback về toạ độ nếu lỗi
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    setState(() => _isLoadingLocation = true);
    
    // Kiểm tra dịch vụ GPS có bật không
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
        _addressText = "GPS chưa bật. Vui lòng bật vị trí.";
      });
      return;
    }

    // Kiểm tra và xin quyền
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          _isLoadingLocation = false;
          _addressText = "Quyền vị trí bị từ chối.";
        });
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
        _addressText = "Quyền bị từ chối vĩnh viễn. Vào cài đặt để mở.";
      });
      return;
    }

    try {
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      
      if (lastPosition != null && mounted) {
        String address = await _getAddressFromLatLng(lastPosition.latitude, lastPosition.longitude);
        setState(() {
          _userLocation = LatLng(lastPosition.latitude, lastPosition.longitude);
          _addressText = address;
        });
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      if (!mounted) return;

      String address = await _getAddressFromLatLng(position.latitude, position.longitude);

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _addressText = address; 
        _isLoadingLocation = false;
      });

    } on TimeoutException catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingLocation = false);
      if (_userLocation == null) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("GPS phản hồi chậm. Vui lòng thử lại hoặc di chuyển ra thoáng hơn.")),
        );
      }
    } catch (e) {
      debugPrint("Lỗi lấy vị trí: $e");
      if (!mounted) return;
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final int totalPayment = cart.totalPrice.toInt() + _shippingFee;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Xác nhận đơn hàng", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Giao đến", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Vị trí hiện tại", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          _userLocation == null ? "Đang định vị..." : _addressText,
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _getCurrentLocation,
                    icon: _isLoadingLocation 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.my_location, color: Colors.blue),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            const Text("Chi tiết thanh toán", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Tổng tiền món", formatVND(cart.totalPrice.toInt())),
                  const SizedBox(height: 10),
                  _buildSummaryRow("Phí giao hàng", formatVND(_shippingFee)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tổng thanh toán", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(formatVND(totalPayment.toInt()), 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // --- NÚT ĐẶT HÀNG ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, 
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          onPressed: _isPlacingOrder ? null : () => _handlePlaceOrder(cart),
          child: _isPlacingOrder 
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : const Text("ĐẶT HÀNG NGAY", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Future<void> _handlePlaceOrder(CartProvider cart) async {
    if (_userLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chưa có vị trí giao hàng. Vui lòng bấm nút định vị.")),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final order = _createOrderObject(cart); 
      
      final body = jsonEncode(order.toJson());
      
      final String baseUrl = "http://10.0.2.2:3000/orders";
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final createdOrder = OrderModel.fromJson(responseData);
        
        cart.clearCart(widget.userId); 
        
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OrderDetailScreen(order: createdOrder)),
            (route) => route.isFirst,
          );
        }
      } else {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi Server: ${response.statusCode}")));
      }

    } catch (e) {
      debugPrint("Lỗi đặt hàng: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lỗi kết nối đến máy chủ")));
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  OrderModel _createOrderObject(CartProvider cart) {
    final pickup = LatLng(10.800669, 106.661126); 
    
    final delivery = _userLocation!; 

    List<OrderItem> orderItems = cart.items.map((item) {
      return OrderItem(
        productId: item.productId,
        name: item.productData['name'],
        quantity: item.quantity,
        price: item.productData['price'],
      );
    }).toList();

    return OrderModel(
      userId: widget.userId,
      items: orderItems,
      totalQuantity: cart.totalQuantity,
      price: cart.totalPrice.toInt() + _shippingFee,
      pickupLocation: pickup,
      deliveryLocation: delivery, 
      pickupAddress: "Cửa hàng (CN Cầu vượt Cộng Hoà)",
      deliveryAddress: _addressText,
      status: "pending",
    );
  }
}