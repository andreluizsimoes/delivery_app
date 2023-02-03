import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:delivery_app/app/dto/order_dto.dart';
import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:delivery_app/app/pages/order/order_state.dart';
import 'package:delivery_app/app/repositories/order/order_repository.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderController(this._orderRepository) : super(const OrderState.initial());

  Future<void> load(List<OrderProductDto> products) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      final paymentTypes = await _orderRepository.getAllPaymentTypes();

      emit(state.copyWith(
          orderProducts: products,
          status: OrderStatus.loaded,
          paymentTypes: paymentTypes));
    } catch (e, s) {
      log('Erro ao carregar a tela', error: e, stackTrace: s);
      emit(state.copyWith(
          status: OrderStatus.error, errorMessage: 'Erro ao carregar a tela'));
    }
  }

  void increment(int index) {
    final order = [...state.orderProducts];
    final product = order[index];
    // sobrescreve o produto na lista, adicinando 1 no amount
    order[index] = product.copyWith(amount: product.amount + 1);
    emit(state.copyWith(orderProducts: order, status: OrderStatus.updateOrder));
  }

  void decrement(int index) {
    final order = [...state.orderProducts];
    final product = order[index];
    final amount = product.amount;

    if (amount >= 1) {
      // sobrescreve o produto na lista, tirando 1 no amount
      order[index] = product.copyWith(amount: product.amount - 1);
    }
    emit(state.copyWith(orderProducts: order, status: OrderStatus.updateOrder));
  }

  void deleteProduct(int index) {
    final order = [...state.orderProducts];
    order.removeAt(index);

    if (order.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyBag));
      return;
    } else {
      emit(state.copyWith(
          orderProducts: order, status: OrderStatus.updateOrder));
    }
  }

  void cleanBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  void saveOrder({
    required String address,
    required String cpf,
    required int paymentMethodId,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));

    await _orderRepository.saveOrder(OrderDto(
      products: state.orderProducts,
      address: address,
      cpf: cpf,
      paymentMethodId: paymentMethodId,
    ));
    emit(state.copyWith(status: OrderStatus.success));
  }

  Future<void> clearZeroAmoutProducts(
      List<OrderProductDto> orderProducts) async {
    for (var product in orderProducts) {
      if (product.amount == 0) {
        orderProducts.remove(product);
        if (orderProducts.isEmpty) {
          emit(state.copyWith(status: OrderStatus.emptyBag));
          return;
        }
      }
    }
  }
}
