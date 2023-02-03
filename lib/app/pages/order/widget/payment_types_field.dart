import 'package:delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';

import '../../../models/payment_type_model.dart';

class PaymentTypesField extends StatelessWidget {
  final List<PaymentTypeModel> paymentTypes;
  final ValueChanged<int> valueChanged;
  final bool valid;
  final String valueSelected;

  const PaymentTypesField({
    super.key,
    required this.paymentTypes,
    required this.valueChanged,
    required this.valid,
    required this.valueSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forma de Pagamento:',
          style: context.textStyles.textRegular.copyWith(fontSize: 16),
        ),
        SmartSelect<String>.single(
          title: '',
          selectedValue: valueSelected,
          onChange: (selected) {
            valueChanged(int.parse(selected.value));
          },
          modalType: S2ModalType.bottomSheet,
          modalConfig: const S2ModalConfig(
            confirmIcon: Icon(Icons.done_outline),
          ),
          modalHeaderStyle: S2ModalHeaderStyle(
            centerTitle: true,
            actionsIconTheme: IconThemeData(
              color: context.colors.primary,
              size: 30,
            ),
          ),
          tileBuilder: (context, state) {
            return InkWell(
              onTap: state.showModal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: context.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          state.selected.title ?? 'Selecione',
                          style: context.textStyles.textRegular,
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          choiceItems: S2Choice.listFrom<String, Map<String, String>>(
            source: paymentTypes
                .map((p) => {
                      'value': p.id.toString(),
                      'title': p.name,
                    })
                .toList(),
            title: (index, item) => item['title'] ?? '',
            value: (index, item) => item['value'] ?? '',
            group: (index, item) =>
                'Selecione forma de pagamento abaixo e confirme ⬈',
          ),
          choiceType: S2ChoiceType.chips,
          choiceStyle: const S2ChoiceStyle(showCheckmark: true),
          choiceGrouped: true,
          modalFilter: false,
          placeholder: '',
          modalTitle: 'Forma de Pagamento',
          groupCounter: false,
          modalConfirm: true,
        ),
        Visibility(
            visible: !valid,
            child: Divider(
              color: Colors.red[700],
              thickness: 1.2,
            )),
        Visibility(
            visible: !valid,
            child: Text(
              'Selecione a forma de pagamento',
              style: context.textStyles.textRegular.copyWith(
                fontSize: 12,
                color: Colors.red,
              ),
            ))
      ],
    );
  }
}
