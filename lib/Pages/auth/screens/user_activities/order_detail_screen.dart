import 'package:fast_food_app/Core/providers/order_provider.dart';
import 'package:fast_food_app/pages/auth/screens/app_main_screen.dart';
import 'package:fast_food_app/widgets/order_details/order_header_section.dart';
import 'package:fast_food_app/widgets/order_details/order_list.dart';
import 'package:fast_food_app/widgets/order_details/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_app/Core/models/order_model.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderModel currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
  }

  Future<void> _handleRefresh() async {
    final provider = Provider.of<OrderProvider>(context, listen: false);
    
    await provider.fetchOrders(currentOrder.userId);

    if (mounted) {
      setState(() {
        try {
          currentOrder = provider.orders.firstWhere((o) => o.id == widget.order.id);
        } catch (e) {
          print("Không tìm thấy đơn hàng");
        }
      });
    }
  }

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
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AppMainScreen()),
                (route) => false,
              );
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.red,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderHeaderSection(order: currentOrder),
                const SizedBox(height: 30),
                const Text(
                  "Sản phẩm:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                
                OrderList(items: currentOrder.items),

                const SizedBox(height: 100), 
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: OrderSummarySection(order: currentOrder),
    );
  }
}