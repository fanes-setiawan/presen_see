import 'package:flutter/material.dart';
import 'package:presen_see/core/constant/app_color.dart';

class CustomPassField extends StatelessWidget {
  final TextEditingController? controller;
  const CustomPassField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Masukan Password",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 5.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(width: 1.5, color: AppColors.primaryDark),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: TextFormField(
                initialValue: null,
                controller: controller,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration.collapsed(
                  filled: true,
                  fillColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  hintText: "Password",
                ),

                onFieldSubmitted: (value) {},
              ),
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            "Lupa Password?",
            style: TextStyle(
              fontSize: 14.0,
              color: AppColors.accent,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
