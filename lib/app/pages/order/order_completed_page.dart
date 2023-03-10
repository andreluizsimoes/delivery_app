import 'package:delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:flutter/material.dart';

class OrderCompletedPage extends StatelessWidget {
  const OrderCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/stars.png',
            height: context.screenHeight,
            width: context.screenWidth,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: context.percentHeight(.15),
                ),
                Image.asset('assets/images/yodalogo.png'),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Pedido realizado com sucesso! C3-PO vai preparar o seu Burger e em breve levaremos até você na Millennium Falcon!\nMay the Force be with you! ',
                    textAlign: TextAlign.center,
                    style: context.textStyles.textExtraBold
                        .copyWith(fontSize: 20, color: Colors.amber),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DeliveryButton(
                  width: context.percentWidth(.80),
                  label: 'FECHAR',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
