import 'package:delivery_app/app/core/extensions/formatter_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_increment_decrement_button.dart';
import 'package:delivery_app/app/pages/order/order_controller.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class OrderProductTile extends StatelessWidget {
  final int index;
  final OrderProductDto orderProduct;

  const OrderProductTile({
    super.key,
    required this.index,
    required this.orderProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/loading.gif',
              image: orderProduct.product.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderProduct.product.name,
                    textAlign: TextAlign.start,
                    style: context.textStyles.textRegular.copyWith(
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    (orderProduct.product.price * orderProduct.amount)
                        .currencyPTBR,
                    style: context.textStyles.textMedium.copyWith(
                      fontSize: 15,
                      color: context.colors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //! Se usuário diminuir à 0, o botão decrement sai de cena para a confirmação visual com UNDO ou LIXO,
              // que se clicada exclui o produto
              orderProduct.amount != 0
                  ? DeliveryIncrementDecrementButton.compact(
                      amount: orderProduct.amount,
                      incrementTap: () {
                        context.read<OrderController>().increment(index);
                      },
                      decrementTap: () {
                        context.read<OrderController>().decrement(index);
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              context.read<OrderController>().increment(index);
                            },
                            icon: const Icon(
                              Icons.replay,
                              color: Colors.green,
                              size: 25,
                            )),
                        IconButton(
                          onPressed: () {
                            context
                                .read<OrderController>()
                                .deleteProduct(index);
                          },
                          icon: SvgPicture.asset(
                            'assets/images/trash.svg',
                            color: Colors.red,
                            width: 25,
                          ),
                        )
                      ],
                    )
            ],
          )
        ],
      ),
    );
  }
}
