import 'package:delivery_app/app/dto/order_product_dto.dart';

class OrderDto {
  final List<OrderProductDto> products;
  final String address;
  final String cpf;
  final int paymentMethodId;
  
  OrderDto({
    required this.products,
    required this.address,
    required this.cpf,
    required this.paymentMethodId,
  });
}
