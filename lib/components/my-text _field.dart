import 'package:flutter/material.dart';

class My_text_feild extends StatelessWidget {
  final String hintText;
  final controller;
  const My_text_feild({super.key, required this.hintText,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            fillColor: const Color(0xFFBFDDE4),
            filled: true),
      ),
    );
  }
}
