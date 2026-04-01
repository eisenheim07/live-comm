class ProductModel {
  final String? id;
  final String? shopName;
  final String? title;
  final String? description;
  final double? price;
  final double? discountPrice;
  final int? stock;
  final String? imageUrl;
  final String? categoryId;
  final bool? isLiveProduct;
  final String? createdAt;

  const ProductModel({
    this.id,
    this.shopName,
    this.title,
    this.description,
    this.price,
    this.discountPrice,
    this.stock,
    this.imageUrl,
    this.categoryId,
    this.isLiveProduct,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString(),
      shopName: _extractShopName(json['seller_id']),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      price: _parseDouble(json['price']),
      discountPrice: _parseDouble(json['discount_price']),
      stock: _parseInt(json['stock']),
      imageUrl: _extractImageUrl(json['images']),
      categoryId: json['category_id']?.toString(),
      isLiveProduct: json['is_live_product'] as bool?,
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
    );
  }

  static String? _extractShopName(dynamic sellerId) {
    if (sellerId == null) return null;
    if (sellerId is Map<String, dynamic>) {
      return sellerId['shop_name']?.toString();
    }
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _extractImageUrl(dynamic images) {
    if (images == null) return null;
    if (images is List && images.isNotEmpty) {
      final firstImage = images[0];
      if (firstImage is Map<String, dynamic>) {
        return firstImage['url']?.toString();
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'shop_name': shopName,
      'title': title,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'stock': stock,
      'images': imageUrl != null ? [{'url': imageUrl}] : null,
      'category_id': categoryId,
      'is_live_product': isLiveProduct,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, shopName: $shopName, title: $title, price: $price, discountPrice: $discountPrice, stock: $stock, isLiveProduct: $isLiveProduct)';
  }
}