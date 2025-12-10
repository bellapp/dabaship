import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  pending,
  assigned,
  pickedUp,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cash,
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

class OrderModel {
  final String orderId;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final GeoPoint deliveryLocation;
  final String deliveryAddress;
  final PaymentMethod paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final String? riderId;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.deliveryLocation,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.riderId,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList() ?? [],
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      deliveryLocation: data['deliveryLocation'] as GeoPoint,
      deliveryAddress: data['deliveryAddress'] ?? '',
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == data['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      riderId: data['riderId'],
    );
  }

  OrderModel copyWith({
    String? orderId,
    String? userId,
    List<OrderItem>? items,
    double? totalAmount,
    GeoPoint? deliveryLocation,
    String? deliveryAddress,
    PaymentMethod? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    String? riderId,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      riderId: riderId ?? this.riderId,
    );
  }
}
