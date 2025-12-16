import 'package:fast_food_app/Core/utils/consts.dart';
import 'package:fast_food_app/Core/utils/format.dart';
import 'package:flutter/material.dart';

class CartBar extends StatelessWidget {
  final double totalPrice;
  final int totalQuantity;
  final bool isPlacingOrder;
  final VoidCallback onOrderPress;

  const CartBar({
    super.key,
    required this.totalPrice,
    required this.totalQuantity,
    required this.isPlacingOrder,
    required this.onOrderPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tổng tiền", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  formatVND(totalPrice.toInt()),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: red),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                minimumSize: const Size(150, 50),
              ),
              onPressed: isPlacingOrder ? null : onOrderPress,
              child: isPlacingOrder
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Row(
                      children: [
                        const Text("Thanh toán", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}