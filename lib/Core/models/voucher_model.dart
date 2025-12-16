enum VoucherType { freeShip, percentage, fixedAmount }

class VoucherModel {
  final String code;
  final VoucherType type;
  final double value; // Giá trị giảm (VD: 15000 cho freeShip, 10 cho 10%)
  final double minOrderValue; // Đơn tối thiểu để áp dụng
  final String description;

  VoucherModel({
    required this.code,
    required this.type,
    required this.value,
    required this.minOrderValue,
    required this.description,
  });
}

final List<VoucherModel> sampleVouchers = [
  VoucherModel(
    code: "FREESHIP",
    type: VoucherType.freeShip,
    value: 15000, // Giảm tối đa 15k phí ship
    minOrderValue: 0,
    description: "Miễn phí vận chuyển",
  ),
  VoucherModel(
    code: "GIAM10",
    type: VoucherType.percentage,
    value: 10, // Giảm 10%
    minOrderValue: 100000, // Đơn trên 100k mới được dùng
    description: "Giảm 10% cho đơn từ 100k",
  ),
  VoucherModel(
    code: "CHAOBANMOI",
    type: VoucherType.fixedAmount,
    value: 20000, // Giảm thẳng 20k
    minOrderValue: 50000,
    description: "Giảm 20k cho đơn từ 50k",
  ),
];