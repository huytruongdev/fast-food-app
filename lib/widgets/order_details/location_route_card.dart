import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:flutter/material.dart';

class LocationRouteCard extends StatelessWidget {
  final OrderModel order;
  const LocationRouteCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildLocationRow(
            icon: Icons.store_mall_directory,
            iconColor: Colors.red,
            title: "Lấy hàng tại",
            address: order.pickupAddress,
            isLast: false,
          ),
          _buildLocationRow(
            icon: Icons.location_on,
            iconColor: Colors.blue,
            title: "Giao đến",
            address: order.deliveryAddress,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String address,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            if (!isLast)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                height: 30,
                width: 2,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(fontWeight: FontWeight.w500, height: 1.3),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}