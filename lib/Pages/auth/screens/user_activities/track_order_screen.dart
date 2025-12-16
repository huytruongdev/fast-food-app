import 'package:fast_food_app/Core/providers/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:provider/provider.dart';

class TrackOrderScreen extends StatelessWidget {
  final OrderModel order;
  const TrackOrderScreen({super.key, required this.order});

  // 1. Helper: Lấy màu dựa trên trạng thái
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'accepted':
        return Colors.orange;
      case 'shipping':
        return Colors.blue;
      case 'arrived':
        return Colors.red;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // 2. Helper: Lấy text hiển thị tiếng Việt
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return "Đang tìm tài xế...";
      case 'accepted':
        return "Tài xế đang đến lấy hàng";
      case 'shipping':
        return "Tài xế đang giao đến bạn";
      case 'arrived':
        return "Tài xế sắp đến nơi. Hãy chú ý điện thoại!";
      case 'delivered':
        return "Giao hàng thành công";
      default:
        return "Trạng thái: $status";
    }
  }

  @override
  Widget build(BuildContext context) {
    String orderId = order.id?.substring(0, 6).toUpperCase() ?? '';

    return ChangeNotifierProvider(
      create: (_) => TrackingProvider()..init(order),
      child: Scaffold(
        appBar: AppBar(title: Text("Theo dõi đơn hàng #$orderId")),
        body: Consumer<TrackingProvider>(
          builder: (context, provider, child) {
            String currentDisplayStatus = provider.currentStatus ?? order.status ?? "pending";

            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: provider.shopLocation,
                    zoom: 14,
                  ),
                  markers: provider.markers,
                  polylines: provider.polylines,
                  onMapCreated: (GoogleMapController controller) {
                    provider.setMapController(controller);
                  },
                ),

                // --- STATUS CHIP ---
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getStatusColor(currentDisplayStatus),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getStatusColor(currentDisplayStatus).withOpacity(0.4),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _getStatusText(currentDisplayStatus),
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      provider.findDriver();
                    },
                    label: const Text('Định vị tài xế'),
                    icon: const Icon(Icons.directions_bike),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}