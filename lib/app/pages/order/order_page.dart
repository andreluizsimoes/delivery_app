import 'package:delivery_app/app/core/extensions/formatter_extensions.dart';
import 'package:delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/app/dto/order_product_dto.dart';
import 'package:delivery_app/app/models/payment_type_model.dart';
import 'package:delivery_app/app/pages/order/order_controller.dart';
import 'package:delivery_app/app/pages/order/order_state.dart';
import 'package:delivery_app/app/pages/order/widget/order_field.dart';
import 'package:delivery_app/app/pages/order/widget/order_product_tile.dart';
import 'package:delivery_app/app/pages/order/widget/payment_types_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:validatorless/validatorless.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final _cpfEC = TextEditingController();
  final _enderecoEC = TextEditingController();
  int? paymentTypeId;
  ValueNotifier<bool> paymentTypeValid = ValueNotifier(true);

  @override
  void onReady() {
    super.onReady();
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    controller.load(products);
  }

  @override
  void dispose() {
    super.dispose();
    _cpfEC.dispose();
    _enderecoEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () {
            showLoader();
          },
          error: () {
            hideLoader();
            showError(state.errorMessage!);
          },
          emptyBag: () {
            showInfo(
                'Sacola sem itens!\nNão vá para outra galáxia de barriga vazia!');
            Navigator.pop(context, <OrderProductDto>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed('order/completed',
                result: <OrderProductDto>[]);
          },
        );
      },
      child: WillPopScope(
        // Widget usado para passagem de atributos pela navegação
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProducts);
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppbar(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Text(
                          'Carrinho',
                          style: context.textStyles.textTitle,
                        ),
                        IconButton(
                          onPressed: () {
                            controller.cleanBag();
                          },
                          icon: SvgPicture.asset(
                            'assets/images/trash.svg',
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, orderProducts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orderProducts.length,
                        (context, index) {
                          final orderProduct = orderProducts[index];
                          return Column(
                            children: [
                              OrderProductTile(
                                index: index,
                                orderProduct: orderProduct,
                              ),
                              const Divider(
                                color: Colors.grey,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'VALOR TOTAL DO PEDIDO:',
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            BlocBuilder<OrderController, OrderState>(
                              builder: (context, state) {
                                return Text(
                                  state.totalOrderPrice.currencyPTBR,
                                  style:
                                      context.textStyles.textExtraBold.copyWith(
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      OrderField(
                        title: 'Endereço de entrega:',
                        controller: _enderecoEC,
                        validator:
                            Validatorless.required('Endereço é obrigatório'),
                        hintText: 'Digite o endereço',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'CPF:',
                        controller: _cpfEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('CPF é obrigatório'),
                          Validatorless.cpf('CPF inválido!')
                        ]),
                        hintText: 'Digite o CPF',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentTypes) {
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValidValue, child) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: PaymentTypesField(
                                  paymentTypes: paymentTypes,
                                  valueChanged: (value) {
                                    paymentTypeId = value;
                                  },
                                  valid: paymentTypeValidValue,
                                  valueSelected: paymentTypeId.toString(),
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, orderProducts) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Divider(
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: DeliveryButton(
                              width: double.infinity,
                              height: 48,
                              label: 'FINALIZAR',
                              onPressed: () {
                                final valid =
                                    formKey.currentState?.validate() ?? false;
                                final paymentTypeSelected =
                                    paymentTypeId != null;
                                paymentTypeValid.value = paymentTypeSelected;

                                controller
                                    .clearZeroAmoutProducts(orderProducts);

                                if (valid && paymentTypeSelected) {
                                  controller.saveOrder(
                                    address: _enderecoEC.text,
                                    cpf: _cpfEC.text,
                                    paymentMethodId: paymentTypeId!,
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
