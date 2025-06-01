import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Image category;
  final String label;
  final VoidCallback onPressed;
  const CategoryItem({super.key, required this.category, required this.label,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(onPressed: onPressed, 
        icon: category),
        Text(label),
      ],
    );
  }
}
