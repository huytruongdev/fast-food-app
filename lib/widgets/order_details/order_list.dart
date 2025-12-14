import 'package:fast_food_app/Core/utils/format.dart';
import 'package:flutter/material.dart';

// --- WIDGET CON 2: DANH SÁCH SẢN PHẨM ---
class OrderList extends StatelessWidget {
  final List<dynamic> items; 
  const OrderList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        
        final double totalLinePrice = (item.price * item.quantity).toDouble();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.quantity} x ${item.name}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Đơn giá: ${formatVND(item.price)}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 10),

            // 2. Tổng tiền (Bên phải)
            Text(
              formatVND(totalLinePrice.toInt()), // Hiển thị kết quả nhân
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: Colors.black87
              ),
            ),
          ],
        );
      },
    );
  }
}