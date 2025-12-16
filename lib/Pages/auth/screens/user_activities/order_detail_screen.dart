import 'package:fast_food_app/Core/providers/order_provider.dart';
import 'package:fast_food_app/pages/auth/screens/app_main_screen.dart';
import 'package:fast_food_app/widgets/order_details/location_route_card.dart';
import 'package:fast_food_app/widgets/order_details/order_header_section.dart';
import 'package:fast_food_app/widgets/order_details/order_list.dart';
import 'package:fast_food_app/widgets/order_details/order_meta_info.dart';
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
    
    await provider.fetchOrders(currentOrder.userId!);

    if (mounted) {
      setState(() {
        try {
          currentOrder = provider.orders.firstWhere((o) => o.id == widget.order.id);
        } catch (e) {
          debugPrint("Không tìm thấy đơn hàng trong danh sách mới (có thể đã bị hủy)");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Chi tiết đơn hàng", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderMetaInfo(order: currentOrder),
                const SizedBox(height: 16),

                OrderHeaderSection(order: currentOrder),
                const SizedBox(height: 16),

                LocationRouteCard(order: currentOrder),
                const SizedBox(height: 24),

                const Text(
                  "Danh sách món ăn",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: OrderList(items: currentOrder.items),
                ),

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