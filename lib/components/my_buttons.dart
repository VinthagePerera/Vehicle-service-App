import 'package:flutter/material.dart';

class My_Buttons extends StatelessWidget {
  final String text;
  final double size;
  final VoidCallback onpressed;
  

  const My_Buttons({super.key, required this.text, required this.size, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size),
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF130E4E),
            fixedSize: const Size(223, 56)),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
