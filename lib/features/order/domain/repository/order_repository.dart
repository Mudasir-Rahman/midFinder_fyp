// domain/repositories/order_repository.dart


import '../ entities/order_entity.dart';

abstract class OrderRepository {
  // CREATE
  Future<OrderEntity> createOrder(OrderEntity order);

  // READ
  Future<OrderEntity> getOrderById(String orderId);
  Future<List<OrderEntity>> getOrdersByPatientId(String patientId);
  Future<List<OrderEntity>> getOrdersByPharmacyId(String pharmacyId);
  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status);

  // UPDATE
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  });

  Future<OrderEntity> updateOrder(OrderEntity order);

  // DELETE
  Future<void> cancelOrder(String orderId);
  Future<void> deleteOrder(String orderId);

  // SPECIAL QUERIES
  Future<List<OrderEntity>> getRecentOrders({
    required String patientId,
    int limit = 10,
  });

  Future<bool> checkOrderExists(String orderId);

  // REAL-TIME UPDATES
  Stream<OrderEntity> watchOrder(String orderId);
  Stream<List<OrderEntity>> watchPatientOrders(String patientId);
  Stream<List<OrderEntity>> watchPharmacyOrders(String pharmacyId);
}