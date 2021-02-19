import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard(
      {this.cardChild,
        @required this.color,
        //this.onPress
      });

  final Widget cardChild;
  final Color color;
  //final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: onPress,
      child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: cardChild,
          ),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}