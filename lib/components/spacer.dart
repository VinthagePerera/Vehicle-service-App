import 'package:flutter/material.dart';

class Space extends StatefulWidget {
  final String text;
  final String secondText;
  const Space({Key? key, required this.text, required this.secondText}) : super(key: key);

  @override
  State<Space> createState() => _SpaceState();
}

class _SpaceState extends State<Space> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Row(
        children: [
          Text(widget.text,
          style: TextStyle(fontSize: 18),),
          Spacer(),
          Text(widget.secondText,
          style: TextStyle(fontSize: 18),),
        ],
      ),
    );
  }
}
