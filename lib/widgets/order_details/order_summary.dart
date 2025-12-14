import 'package:fast_food_app/Core/utils/consts.dart';
import 'package:fast_food_app/Core/utils/format.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:fast_food_app/pages/auth/screens/user_activities/track_order_screen.dart';
import 'package:flutter/material.dart';

class OrderSummarySection extends StatelessWidget {
  final OrderModel order;
  const OrderSummarySection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Tổng cộng:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              formatVND(order.price),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: red),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: red,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackOrderScreen(order: order)),
              );
            },
            child: const Text(
              "Theo dõi đơn hàng (Track Order)",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}