String formatVND(int price) {
  // Logic: Thêm dấu chấm sau mỗi 3 số 0
  final priceString = price.toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
  return "$priceString đ";
}