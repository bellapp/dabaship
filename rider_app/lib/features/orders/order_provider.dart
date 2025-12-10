import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'order_model.dart';
import 'order_service.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService();
});

final availableOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(orderServiceProvider).getAvailableOrders();
});

final riderActiveOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(orderServiceProvider).getRiderActiveOrders();
});

final riderCompletedOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(orderServiceProvider).getRiderCompletedOrders();
});
