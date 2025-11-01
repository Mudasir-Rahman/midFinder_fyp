import '../../../../core/error/failures.dart';
import '../../domain/ entities/order_entity.dart';

import '../../domain/repository/order_repository.dart';
import '../data_source/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderEntity> createOrder(OrderEntity order) async {
    try {
      _validateOrder(order);
      return await remoteDataSource.createOrder(order);
    } on Failure {
      rethrow;
    } catch (e) {
      throw OrderCreationFailure(e.toString());
    }
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    try {
      return await remoteDataSource.getOrderById(orderId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw OrderNotFoundFailure(orderId);
    }
  }

  @override
  Future<List<OrderEntity>> getOrdersByPatientId(String patientId) async {
    try {
      return await remoteDataSource.getOrdersByPatientId(patientId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to fetch patient orders: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderEntity>> getOrdersByPharmacyId(String pharmacyId) async {
    try {
      return await remoteDataSource.getOrdersByPharmacyId(pharmacyId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to fetch pharmacy orders: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status) async {
    try {
      return await remoteDataSource.getOrdersByStatus(status);
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to fetch orders by status: ${e.toString()}');
    }
  }

  @override
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    try {
      return await remoteDataSource.updateOrderStatus(
        orderId: orderId,
        newStatus: newStatus,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw OrderStatusUpdateFailure(newStatus.displayName);
    }
  }

  @override
  Future<OrderEntity> updateOrder(OrderEntity order) async {
    try {
      return await remoteDataSource.updateOrder(order);
    } on Failure {
      rethrow;
    } catch (e) {
      throw OrderUpdateFailure(e.toString());
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      final order = await getOrderById(orderId);

      if (!order.canBeCancelled) {
        throw OrderCancellationFailure(order.orderStatus.displayName);
      }

      await updateOrderStatus(
        orderId: orderId,
        newStatus: OrderStatus.cancelled,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw OrderProcessingFailure('Failed to cancel order: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      await remoteDataSource.deleteOrder(orderId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw OrderDeletionFailure(e.toString());
    }
  }

  @override
  Future<List<OrderEntity>> getRecentOrders({
    required String patientId,
    int limit = 10,
  }) async {
    try {
      final orders = await getOrdersByPatientId(patientId);
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return orders.take(limit).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to fetch recent orders: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkOrderExists(String orderId) async {
    try {
      await getOrderById(orderId);
      return true;
    } on OrderNotFoundFailure {
      return false;
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to check order existence: ${e.toString()}');
    }
  }

  @override
  Stream<OrderEntity> watchOrder(String orderId) {
    try {
      return remoteDataSource.watchOrder(orderId);
    } catch (e) {
      throw DatabaseFailure('Failed to watch order: ${e.toString()}');
    }
  }

  @override
  Stream<List<OrderEntity>> watchPatientOrders(String patientId) {
    try {
      return remoteDataSource.watchPatientOrders(patientId);
    } catch (e) {
      throw DatabaseFailure('Failed to watch patient orders: ${e.toString()}');
    }
  }

  @override
  Stream<List<OrderEntity>> watchPharmacyOrders(String pharmacyId) {
    try {
      return remoteDataSource.watchPharmacyOrders(pharmacyId);
    } catch (e) {
      throw DatabaseFailure('Failed to watch pharmacy orders: ${e.toString()}');
    }
  }

  // Private validation method
  void _validateOrder(OrderEntity order) {
    if (order.items.isEmpty) {
      throw const EmptyOrderFailure();
    }

    if (order.totalPrice <= 0) {
      throw const InvalidOrderPriceFailure();
    }

    if (order.hasPrescriptionItems && order.prescriptionImageUrl == null) {
      throw const PrescriptionRequiredFailure();
    }

    if (order.isDelivery && order.deliveryAddress == null) {
      throw const DeliveryAddressRequiredFailure();
    }
  }
}