import 'dart:developer';

import 'package:delivery_app/app/core/exceptions/repository_exception.dart';
import 'package:delivery_app/app/models/payment_type_model.dart';
import 'package:dio/dio.dart';

import '../../core/rest_client/custom_dio.dart';
import '../../dto/order_dto.dart';
import './order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final CustomDio dio;

  OrderRepositoryImpl({
    required this.dio,
  });

  @override
  Future<List<PaymentTypeModel>> getAllPaymentTypes() async {
    try {
      final paymentTypes = await dio.auth().get('/payment-types');

      return paymentTypes.data
          .map<PaymentTypeModel>((p) => PaymentTypeModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar formas de pagamento', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar formas de pagamento');
    }
  }

  @override
  Future<void> saveOrder(OrderDto order) async {
    try {
      await dio.auth().post('/orders', data: {
        'products': order.products
            .map((p) => {
                  'id': p.product.id,
                  'amount': p.amount,
                  'total_price': p.totalPrice
                })
            .toList(),
        'user_id': '#userAuthRef',
        'address': order.address,
        'CPF': order.cpf,
        'payment_method_id': order.paymentMethodId
      });
    } on DioError catch (e, s) {
      log('Erro ao registrar o pedido', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao registrar o pedido');
    }
  }
}
