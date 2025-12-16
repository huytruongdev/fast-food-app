import 'dart:convert';
import 'package:fast_food_app/Core/providers/favorite_provider.dart';
import 'package:fast_food_app/Core/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:fast_food_app/Core/models/product_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final String baseUrl = "http://10.0.2.2:3000"; 
  List<FoodModel> products = [];
  bool _loaded = false;
  late final FavoriteProvider _favoriteProvider;

  @override
  void initState() {
    super.initState();
    
    _favoriteProvider = context.read<FavoriteProvider>();

    _favoriteProvider.addListener(_onFavoriteChanged);

    loadFavoriteProducts();
  }

  void _onFavoriteChanged() {
    if (mounted) {
      setState(() {
        _loaded = false;
      });
      loadFavoriteProducts();
    }
  }

  @override
  void dispose() {
    _favoriteProvider.removeListener(_onFavoriteChanged);
    super.dispose();
  }

  Future<void> loadFavoriteProducts() async {
    final provider = context.read<FavoriteProvider>();

    if (provider.favoriteItems.isEmpty) {
      if (mounted) {
        setState(() {
          products = [];
          _loaded = true;
        });
      }
      return;
    }

    try {
      final url = Uri.parse("$baseUrl/products/byIds");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"productIDs": provider.favoriteItems}),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            products = data.map((e) => FoodModel.fromJson(e)).toList();
            _loaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _loaded = true;
          });
        }
        print("Error fetching favorites: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loaded = true;
        });
      }
      print("Exception fetching favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _loaded == false
          ? const Center(child: CircularProgressIndicator())
          : provider.favoriteItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Bạn chưa thích sản phẩm nào", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imageCard,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.fastfood, size: 60, color: Colors.grey),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          formatVND(item.price.toInt()),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            provider.isExist(item.productId)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await provider.toggleFavorite(item.productId);
                            if (mounted) {
                              setState(() {
                                products.removeWhere(
                                  (p) => p.productId == item.productId,
                                );
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}