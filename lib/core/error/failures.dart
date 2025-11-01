// import 'package:equatable/equatable.dart';
//
// abstract class Failure extends Equatable {
//   final String message;
//
//   const Failure(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
// class ServerFailure extends Failure {
//   const ServerFailure(String message) : super(message);
// }
//
// class CacheFailure extends Failure {
//   const CacheFailure(String message) : super(message);
// }
//
// class NetworkFailure extends Failure {
//   const NetworkFailure(String message) : super(message);
// }
//
// class ValidationFailure extends Failure {
//   const ValidationFailure(String message) : super(message);
// }
//
// class AuthFailure extends Failure {
//   const AuthFailure(String message) : super(message);
// }
// class NotFoundFailure extends Failure{
//   const NotFoundFailure(String message) : super(message);
// }
// class UploadFailure extends Failure{
//   const UploadFailure(String message) : super(message);
// }
// class DatabaseFailure extends Failure{
//   const DatabaseFailure(String message) : super(message);
// }
// class GeocodingFailure extends Failure{
//   const GeocodingFailure(String message) : super(message);
//
// }
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message);
}

class UploadFailure extends Failure {
  const UploadFailure(String message) : super(message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message);
}

class GeocodingFailure extends Failure {
  const GeocodingFailure(String message) : super(message);
}

// ORDER-SPECIFIC FAILURES
class OrderFailure extends Failure {
  const OrderFailure(String message) : super(message);
}

class EmptyOrderFailure extends OrderFailure {
  const EmptyOrderFailure() : super('Order must contain at least one item');
}

class InvalidOrderPriceFailure extends OrderFailure {
  const InvalidOrderPriceFailure() : super('Order total price must be greater than zero');
}

class OrderCancellationFailure extends OrderFailure {
  const OrderCancellationFailure(String status)
      : super('Order cannot be cancelled in $status status');
}

class PrescriptionRequiredFailure extends OrderFailure {
  const PrescriptionRequiredFailure()
      : super('Prescription image is required for prescription items');
}

class DeliveryAddressRequiredFailure extends OrderFailure {
  const DeliveryAddressRequiredFailure()
      : super('Delivery address is required for delivery orders');
}

class OrderNotFoundFailure extends NotFoundFailure {
  const OrderNotFoundFailure(String orderId)
      : super('Order with ID $orderId not found');
}

class OrderItemNotFoundFailure extends NotFoundFailure {
  const OrderItemNotFoundFailure(String itemId)
      : super('Order item with ID $itemId not found');
}

class OrderStatusUpdateFailure extends OrderFailure {
  const OrderStatusUpdateFailure(String status)
      : super('Cannot update order status to $status');
}

class OrderCreationFailure extends OrderFailure {
  const OrderCreationFailure(String message) : super('Failed to create order: $message');
}

class OrderUpdateFailure extends OrderFailure {
  const OrderUpdateFailure(String message) : super('Failed to update order: $message');
}

class OrderDeletionFailure extends OrderFailure {
  const OrderDeletionFailure(String message) : super('Failed to delete order: $message');
}

class InsufficientStockFailure extends OrderFailure {
  const InsufficientStockFailure(String medicineName)
      : super('Insufficient stock for $medicineName');
}

class OrderPaymentFailure extends OrderFailure {
  const OrderPaymentFailure(String message) : super('Payment failed: $message');
}

class OrderProcessingFailure extends OrderFailure {
  const OrderProcessingFailure(String message) : super('Order processing failed: $message');
}