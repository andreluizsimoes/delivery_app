import '../../dto/order_dto.dart';
import '../../models/payment_type_model.dart';

abstract class OrderRepository {
  Future<List<PaymentTypeModel>> getAllPaymentTypes();
  Future<void> saveOrder(OrderDto order);
}
