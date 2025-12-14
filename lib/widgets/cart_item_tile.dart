import 'package:fast_food_app/Core/providers/cart_provider.dart';
import 'package:fast_food_app/Core/utils/format.dart';
import 'package:flutter/material.dart';

class CartItemTile extends StatelessWidget {
  final dynamic item; // Nên dùng type cụ thể nếu có (CartItemModel)
  final String userId;
  final CartProvider cartProvider;

  const CartItemTile({
    super.key,
    required this.item,
    required this.userId,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.cartId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => cartProvider.removeItem(item.cartId, userId),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Ảnh sản phẩm
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.productData['imageCard'] ?? "",
                width: 70, height: 70, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 70, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            // Thông tin text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productData['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatVND(item.productData['price']),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Nút tăng giảm
            _buildQuantityControl(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControl() {
    return Row(
      children: [
        _iconBtn(Icons.remove, () {
          if (item.quantity > 1) {
            cartProvider.addCart(userId, item.productId, item.productData, -1);
          } else {
            cartProvider.removeItem(item.cartId, userId);
          }
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        _iconBtn(Icons.add, () {
          cartProvider.addCart(userId, item.productId, item.productData, 1);
        }),
      ],
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}