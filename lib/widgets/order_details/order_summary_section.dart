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
    double itemTotal = order.items.fold(0, (sum, item) => sum + (item.price * item.quantity));

    bool isCompleted = (order.status == 'delivered' || order.status == 'cancelled');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
            // --- CÁC DÒNG CHI TIẾT ---
            
            // 1. Tổng tiền hàng
            _buildRow("Tổng tiền món", formatVND(itemTotal.toInt())),
            const SizedBox(height: 8),

            // 2. Phí giao hàng
            _buildRow("Phí giao hàng", formatVND(order.shippingFee)),
            
            // 3. Giảm giá (Chỉ hiện nếu có)
            if (order.discountAmount > 0) ...[
              const SizedBox(height: 8),
              _buildRow(
                "Giảm giá", 
                "-${formatVND(order.discountAmount)}", 
                valueColor: Colors.green
              ),
            ],

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(),
            ),

            // --- TỔNG THANH TOÁN ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tổng thanh toán:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatVND(order.price),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: red),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // --- NÚT HÀNH ĐỘNG ---
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
                  _getButtonText(order.status),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value, 
          style: TextStyle(
            fontWeight: FontWeight.w500, 
            color: valueColor ?? Colors.black,
            fontSize: 14
          )
        ),
      ],
    );
  }

  String _getButtonText(String? status) {
    if (status == 'cancelled') return "Đơn hàng đã huỷ";
    if (status == 'delivered') return "Giao hàng thành công";
    return "Theo dõi đơn hàng (Track Order)";
  }
}