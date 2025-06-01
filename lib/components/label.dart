import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
    const Label({super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
                      padding: EdgeInsets.only(left: 11),
                      child: Row(
                        children: [
                          Text(
                            text, 
                            style: TextStyle(fontSize:23 ),
                              
                          )
                        ],
                      ),
                    );
  }
}