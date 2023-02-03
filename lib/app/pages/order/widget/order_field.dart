import 'package:delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';

class OrderField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String hintText;

  const OrderField({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    const defaultBorder = UnderlineInputBorder(
        borderSide: BorderSide(
      color: Colors.grey,
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
            child: Text(
              title,
              style: context.textStyles.textRegular.copyWith(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              hintStyle: TextStyle(color: Colors.grey[350]),
              border: defaultBorder,
              enabledBorder: defaultBorder,
              focusedBorder: defaultBorder,
            ),
          )
        ],
      ),
    );
  }
}
