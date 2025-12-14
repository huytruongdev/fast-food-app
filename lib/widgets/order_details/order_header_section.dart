import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderHeaderSection extends StatelessWidget {
  final OrderModel order;
  const OrderHeaderSection({super.key, required this.order});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 80),
          const SizedBox(height: 10),
          const Text(
            "Đặt hàng thành công!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Mã đơn: ${order.id}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 15),
          
          if (order.shipperId != null)
            _buildShipperInfo()
          else
            _buildFindingShipper(),
        ],
      ),
    );
  }

  Widget _buildShipperInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tài xế giao hàng", style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text(
                  order.shipperName ?? "Tài xế công nghệ",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (order.shipperPhone != null)
                  Text(
                    order.shipperPhone!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
              ],
            ),
          ),
          if (order.shipperPhone != null)
            IconButton(
              onPressed: () => {},
              style: IconButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              icon: const Icon(Icons.phone),
            ),
        ],
      ),
    );
  }

  Widget _buildFindingShipper() {
    return const Chip(
      label: Text("Đang tìm tài xế...", style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.orange,
      avatar: Icon(Icons.search, color: Colors.white, size: 18),
    );
  }
}