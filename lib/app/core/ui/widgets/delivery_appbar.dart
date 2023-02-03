import 'package:flutter/material.dart';

class DeliveryAppbar extends AppBar {
  
  DeliveryAppbar({
    super.key,
    double elevation = 1,
  }) : super(
          elevation: elevation,
          title: Image.asset(
            'assets/images/yodalogoappbar.png',
            width: 120,
          ),
        );
}
