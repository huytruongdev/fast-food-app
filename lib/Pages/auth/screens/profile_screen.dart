import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_food_app/service/auth_service.dart';
import 'package:fast_food_app/pages/auth/screens/user_activities/order_detail_screen.dart';
import 'package:fast_food_app/Core/providers/order_provider.dart'; 
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService authService = AuthService();
  String? currentUserId;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    String? userId = await authService.getCurrentUserId();
    if (mounted) {
      setState(() {
        currentUserId = userId;
        isLoadingUser = false;
      });

      if (userId != null) {
        Provider.of<OrderProvider>(context, listen: false).fetchOrders(userId);
      }
    }
  }

  String formatTimeAgo(String? dateString) {
    if (dateString == null) return '';
    DateTime dateTimeUtc = DateTime.parse(dateString);
    DateTime dateTimeLocal = dateTimeUtc.toLocal();
    return timeago.format(dateTimeLocal, locale: 'vi', allowFromNow: true);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'accepted': return Colors.blue;
      case 'shipping': return Colors.cyan;
      case 'delivered': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  String getStatusText(String status) {
     switch (status.toLowerCase()) {
      case 'pending': return 'Chờ xác nhận';
      case 'accepted': return 'Đã nhận đơn';
      case 'shipping': return 'Đang giao';
      case 'delivered': return 'Hoàn thành';
      case 'cancelled': return 'Đã huỷ';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (currentUserId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Phiên đăng nhập hết hạn"),
              ElevatedButton(
                onPressed: () => authService.logout(context),
                child: const Text("Đăng nhập lại"),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản của tôi"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 35)),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Xin chào User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Thành viên Vàng", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => authService.logout(context),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  tooltip: "Đăng xuất",
                )
              ],
            ),
          ),
          
          const Divider(thickness: 2, color: Colors.grey),
          
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Lịch sử đơn hàng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_basket_outlined, size: 50, color: Colors.grey),
                        Text("Bạn chưa có đơn hàng nào", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: provider.orders.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final order = provider.orders[index];
                    
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(order: order),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Card
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Đơn #${order.id!.substring(0, 6).toUpperCase()}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(order.status ?? "").withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: getStatusColor(order.status ?? "")),
                                    ),
                                    child: Text(
                                      getStatusText(order.status ?? "Unknown"),
                                      style: TextStyle(
                                        color: getStatusColor(order.status ?? ""),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              // Thời gian
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  const SizedBox(width: 5),
                                  Text(
                                    formatTimeAgo(order.createdAt),
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  ),
                                ],
                              ),
                              
                              const Divider(),
                              
                              // Giá tiền
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${order.items.length} món", style: const TextStyle(color: Colors.grey)),
                                  Text(
                                    NumberFormat.currency(locale: 'vi', symbol: 'đ').format(order.price),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}