
import 'package:fast_food_app/pages/auth/screens/app_main_screen.dart';
import 'package:fast_food_app/widgets/order_details/order_header_section.dart';
import 'package:fast_food_app/widgets/order_details/order_list.dart';
import 'package:fast_food_app/widgets/order_details/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_app/Core/models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết đơn hàng"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppMainScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeaderSection(order: order),
            
            const SizedBox(height: 30),

            const Text(
              "Sản phẩm:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(child: OrderList(items: order.items)),

            const Divider(),
            
            OrderSummarySection(order: order),
          ],
        ),
      ),
    );
  }
}