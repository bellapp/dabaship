class Product {
  final String? id;
  final String name;
  final double price;
  final String imageUrl;
  final String categoryId;
  final String description;
  final bool isAvailable;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.description,
    required this.isAvailable,
  });

  factory Product.fromJson(Map<String, dynamic> json, {String? id}) {
    return Product(
      id: id,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      categoryId: json['category_id'] as String,
      description: json['description'] as String,
      isAvailable: json['is_available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'description': description,
      'is_available': isAvailable,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? categoryId,
    String? description,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
