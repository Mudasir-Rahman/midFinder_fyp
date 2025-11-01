
import '../../domain/ entities/order_entity.dart';

abstract class OrderRemoteDataSource {
  Future<OrderEntity> createOrder(OrderEntity order);
  Future<OrderEntity> getOrderById(String orderId);
  Future<List<OrderEntity>> getOrdersByPatientId(String patientId);
  Future<List<OrderEntity>> getOrdersByPharmacyId(String pharmacyId);
  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status);
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  });
  Future<OrderEntity> updateOrder(OrderEntity order);
  Future<void> deleteOrder(String orderId);
  Stream<OrderEntity> watchOrder(String orderId);
  Stream<List<OrderEntity>> watchPatientOrders(String patientId);
  Stream<List<OrderEntity>> watchPharmacyOrders(String pharmacyId);
}