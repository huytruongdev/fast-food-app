import 'package:flutter/material.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:fast_food_app/service/order_service.dart';
import 'package:fast_food_app/service/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  final SocketService _socketService = SocketService();

  List<OrderModel> orders = [];
  bool isLoading = false;

  Future<void> fetchOrders(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      orders = await _orderService.getOrdersByUser(userId);
      
      _listenToOrderUpdates();
    } catch (e) {
      print("Lỗi lấy đơn hàng: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _listenToOrderUpdates() {
    _socketService.initSocket();
    final socket = _socketService.getSocket();

    if (socket == null) return;

    void joinAllRooms() {
      for (var order in orders) {
        if (order.status != 'delivered' && order.status != 'cancelled' && order.id != null) {
          _socketService.joinOrderRoom(order.id!);
        }
      }
    }

    if (socket.connected) {
      joinAllRooms();
    }

    socket.onConnect((_) {
      joinAllRooms();
    });

    socket.on('order_status_update', (data) {
      print("🔔 Có biến cập nhật từ Server: $data");

      String orderId = data['orderId'];
      String newStatus = data['status'];

      int index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        print("✅ Cập nhật đơn hàng $orderId: ${orders[index].status} -> $newStatus");
        orders[index].status = newStatus;
        notifyListeners(); 
      }
    });
  }

  @override
  void dispose() {
    _socketService.getSocket()?.off('order_status_update');
    super.dispose();
  }
}