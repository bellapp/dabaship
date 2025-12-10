import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get available orders (pending status, no rider assigned)
  Stream<List<OrderModel>> getAvailableOrders() {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .where('riderId', isNull: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get rider's active orders
  Stream<List<OrderModel>> getRiderActiveOrders() {
    final riderId = _auth.currentUser?.uid;
    if (riderId == null) return Stream.value([]);

    return _firestore
        .collection('orders')
        .where('riderId', isEqualTo: riderId)
        .where('status', whereIn: ['assigned', 'pickedUp'])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get rider's completed orders
  Stream<List<OrderModel>> getRiderCompletedOrders() {
    final riderId = _auth.currentUser?.uid;
    if (riderId == null) return Stream.value([]);

    return _firestore
        .collection('orders')
        .where('riderId', isEqualTo: riderId)
        .where('status', isEqualTo: 'delivered')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    });
  }

  // Accept an order
  Future<void> acceptOrder(String orderId) async {
    final riderId = _auth.currentUser?.uid;
    if (riderId == null) throw Exception('Rider not authenticated');

    await _firestore.collection('orders').doc(orderId).update({
      'riderId': riderId,
      'status': OrderStatus.assigned.name,
      'assignedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status.name,
      if (status == OrderStatus.pickedUp) 'pickedUpAt': FieldValue.serverTimestamp(),
      if (status == OrderStatus.delivered) 'deliveredAt': FieldValue.serverTimestamp(),
    });
  }

  // Get single order
  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) return null;
    return OrderModel.fromFirestore(doc);
  }
}
