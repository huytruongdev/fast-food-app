import 'package:flutter/material.dart';

class OrderStatusHelper {
  
  static String getText(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return "Đang tìm tài xế";
      case 'accepted':
        return "Tài xế đang đến quán";
      case 'shipping':
        return "Đang giao hàng";
      case 'arrived':
        return "Tài xế đã đến nơi";
      case 'delivered':
        return "Hoàn thành";
      case 'cancelled':
        return "Đã hủy";
      default:
        return "Chờ xử lý";
    }
  }

  static Color getColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange; // Màu chờ
      case 'accepted':
        return Colors.blue;   // Màu xanh dương (đang hoạt động)
      case 'shipping':
        return Colors.cyan;   // Màu xanh lơ (đang di chuyển)
      case 'arrived':
        return Colors.purple; // Màu tím (chú ý: đã đến)
      case 'delivered':
        return Colors.green;  // Màu xanh lá (thành công)
      case 'cancelled':
        return Colors.red;    // Màu đỏ (thất bại)
      default:
        return Colors.grey;
    }
  }
}