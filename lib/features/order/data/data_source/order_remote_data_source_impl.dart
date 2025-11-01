// data/datasources/remote/order_remote_data_source_impl.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/ entities/order_entity.dart';
import 'order_remote_data_source.dart';


class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final SupabaseClient supabaseClient;

  OrderRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<OrderEntity> createOrder(OrderEntity order) async {
    final orderMap = _orderToMap(order);

    // Create the order
    final orderResponse = await supabaseClient
        .from('orders')
        .insert(orderMap)
        .select('''
          *,
          pharmacies:pharmacy_id(pharmacy_name),
          patients:patient_id(name, phone, address)
        ''')
        .single();

    final createdOrderId = orderResponse['id'];

    // Create order items
    for (final item in order.items) {
      await supabaseClient
          .from('order_items')
          .insert(_orderItemToMap(createdOrderId, item));
    }

    // Return the complete order with items
    return await getOrderById(createdOrderId);
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    final response = await supabaseClient
        .from('orders')
        .select('''
          *,
          pharmacies:pharmacy_id(pharmacy_name),
          patients:patient_id(name, phone, address),
          order_items(*)
        ''')
        .eq('id', orderId)
        .single();

    return _orderFromMap(response);
  }

  @override
  Future<List<OrderEntity>> getOrdersByPatientId(String patientId) async {
    final response = await supabaseClient
        .from('orders')
        .select('''
          *,
          pharmacies:pharmacy_id(pharmacy_name),
          patients:patient_id(name, phone, address),
          order_items(*)
        ''')
        .eq('patient_id', patientId)
        .order('created_at', ascending: false);

    return response.map(_orderFromMap).toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersByPharmacyId(String pharmacyId) async {
    final response = await supabaseClient
        .from('orders')
        .select('''
          *,
          pharmacies:pharmacy_id(pharmacy_name),
          patients:patient_id(name, phone, address),
          order_items(*)
        ''')
        .eq('pharmacy_id', pharmacyId)
        .order('created_at', ascending: false);

    return response.map(_orderFromMap).toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status) async {
    final response = await supabaseClient
        .from('orders')
        .select('''
          *,
          pharmacies:pharmacy_id(pharmacy_name),
          patients:patient_id(name, phone, address),
          order_items(*)
        ''')
        .eq('status', status.dbValue)
        .order('created_at', ascending: false);

    return response.map(_orderFromMap).toList();
  }

  @override
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    final response = await supabaseClient
        .from('orders')
        .update({
      'status': newStatus.dbValue,
      'updated_at': DateTime.now().toIso8601String(),
    })
        .eq('id', orderId)
        .select('''
          *,
          pharmacies:pharmacy_id(pharmacy_name),
          patients:patient_id(name, phone, address),
          order_items(*)
        ''')
        .single();

    return _orderFromMap(response);
  }

  @override
  Future<OrderEntity> updateOrder(OrderEntity order) async {
    final response = await supabaseClient
        .from('orders')
        .update(_orderToMap(order))
        .eq('id', order.id)
        .select('''
          *,
          pharmacies:pharmacy_id(pharmacy_name),
          patients:patient_id(name, phone, address),
          order_items(*)
        ''')
        .single();

    return _orderFromMap(response);
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    await supabaseClient
        .from('orders')
        .delete()
        .eq('id', orderId);
  }

  @override
  Stream<OrderEntity> watchOrder(String orderId) {
    return supabaseClient
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId)
        .map((data) => _orderFromMap(data.first));
  }

  @override
  Stream<List<OrderEntity>> watchPatientOrders(String patientId) {
    return supabaseClient
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('patient_id', patientId)
        .order('created_at', ascending: false)
        .map((data) => data.map(_orderFromMap).toList());
  }

  @override
  Stream<List<OrderEntity>> watchPharmacyOrders(String pharmacyId) {
    return supabaseClient
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('pharmacy_id', pharmacyId)
        .order('created_at', ascending: false)
        .map((data) => data.map(_orderFromMap).toList());
  }

  // Helper methods for conversion
  Map<String, dynamic> _orderToMap(OrderEntity order) {
    return {
      if (order.id.isNotEmpty) 'id': order.id,
      'patient_id': order.patientId,
      'pharmacy_id': order.pharmacyId,
      'order_type': order.orderType.dbValue,
      'status': order.orderStatus.dbValue,
      'payment_method': order.paymentMethod.dbValue,
      'order_date': order.orderDate.toIso8601String(),
      'total_price': order.totalPrice,
      'delivery_address': order.deliveryAddress,
      'prescription_image_url': order.prescriptionImageUrl,
      'notes': order.notes,
      'created_at': order.createdAt.toIso8601String(),
      'updated_at': order.updatedAt?.toIso8601String(),
    };
  }

  OrderEntity _orderFromMap(Map<String, dynamic> map) {
    final pharmacyData = map['pharmacies'] as Map<String, dynamic>?;
    final patientData = map['patients'] as Map<String, dynamic>?;
    final orderItems = map['order_items'] as List<dynamic>?;

    return OrderEntity(
      id: map['id'],
      patientId: map['patient_id'],
      pharmacyId: map['pharmacy_id'],
      items: orderItems?.map((item) => _itemFromMap(item)).toList() ?? [],
      orderType: OrderType.fromString(map['order_type']),
      orderStatus: OrderStatus.fromString(map['status']),
      paymentMethod: PaymentMethod.fromString(map['payment_method']),
      orderDate: DateTime.parse(map['order_date']),
      totalPrice: (map['total_price'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deliveryAddress: map['delivery_address'],
      prescriptionImageUrl: map['prescription_image_url'],
      notes: map['notes'],
      pharmacyName: pharmacyData?['pharmacy_name'],
      patientName: patientData?['name'],
      patientPhone: patientData?['phone'],
      patientAddress: patientData?['address'],
    );
  }

  Map<String, dynamic> _orderItemToMap(String orderId, OrderItemEntity item) {
    return {
      'order_id': orderId,
      'medicine_id': item.medicineId,
      'medicine_name': item.medicineName,
      'medicine_image_url': item.medicineImageUrl,
      'medicine_price': item.medicinePrice,
      'quantity': item.quantity,
      'subtotal': item.subtotal,
      'dosage': item.dosage,
      'manufacturer': item.manufacturer,
      'generic_name': item.genericName,
      'description': item.description,
      'category': item.category,
      'requires_prescription': item.requiresPrescription,
    };
  }

  OrderItemEntity _itemFromMap(Map<String, dynamic> map) {
    return OrderItemEntity(
      medicineId: map['medicine_id'],
      medicineName: map['medicine_name'],
      medicineImageUrl: map['medicine_image_url'],
      medicinePrice: (map['medicine_price'] as num).toDouble(),
      quantity: map['quantity'],
      subtotal: (map['subtotal'] as num).toDouble(),
      dosage: map['dosage'],
      manufacturer: map['manufacturer'],
      genericName: map['generic_name'],
      description: map['description'],
      category: map['category'],
      requiresPrescription: map['requires_prescription'],
    );
  }
}