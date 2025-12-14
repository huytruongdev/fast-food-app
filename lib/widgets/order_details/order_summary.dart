import 'package:fast_food_app/Core/Utils/consts.dart';
import 'package:fast_food_app/Core/Utils/format.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:fast_food_app/pages/auth/screens/user_activities/track_order_screen.dart';
import 'package:flutter/material.dart';

class OrderSummarySection extends StatelessWidget {
  final OrderModel order;
  const OrderSummarySection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    bool isCompleted = (order.status == 'delivered' || order.status == 'cancelled');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 15),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.grey : red,
                  shape: const StadiumBorder(),
                  elevation: isCompleted ? 0 : 2,
                ),
                onPressed: isCompleted 
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackOrderScreen(order: order),
                          ),
                        );
                      },
                child: Text(
                  order.status == 'cancelled' 
                      ? "Đơn hàng đã huỷ"
                      : (isCompleted ? "Giao hàng thành công" : "Theo dõi đơn hàng (Track Order)"),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}