class Category {
  final String categoryId;
  final String name;
  final String image;

  Category({required this.categoryId, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'],
      image: json['image'],
    );
  }
}