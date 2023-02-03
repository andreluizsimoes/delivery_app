import 'package:delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: const Color(0xFF020100),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/stars.png',
              height: context.screenHeight,
              width: context.screenWidth,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: context.screenWidth,
                child: Image.asset(
                  'assets/images/bottomburger.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: context.percentHeight(.25),
                  ),
                  Image.asset(
                    'assets/images/yodalogo.png',
                    height: 250,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  DeliveryButton(
                    label: 'ACESSAR',
                    width: context.percentWidth(.6),
                    height: 35,
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/home');
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
