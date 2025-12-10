import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../cart/cart_model.dart';

enum PaymentMethod {
  cash,
  // Future: card, mobile
}

enum OrderStatus {
  pending,
  assigned,
  pickedUp,
  delivered,
  cancelled,
}

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final LatLng deliveryLocation;
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

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => {
        'productId': item.product.id,
        'productName': item.product.name,
        'price': item.product.price,
        'quantity': item.quantity,
        'imageUrl': item.product.imageUrl,
      }).toList(),
      'totalAmount': totalAmount,
      'deliveryLocation': GeoPoint(
        deliveryLocation.latitude,
        deliveryLocation.longitude,
      ),
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod.name,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'riderId': riderId,
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final location = data['deliveryLocation'] as GeoPoint;
    
    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] ?? '',
      items: [], // Items would need Product reconstruction - simplified for now
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      deliveryLocation: LatLng(location.latitude, location.longitude),
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
}
