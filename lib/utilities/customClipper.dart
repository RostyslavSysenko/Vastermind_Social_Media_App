import 'package:flutter/material.dart';

class CustomClip extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double lengthOfBar = size.height/1.2;
    double radius = size.width*1.5;
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, lengthOfBar);

    path.arcToPoint(Offset(size.width/2,lengthOfBar), radius: Radius.circular(radius));
    path.arcToPoint(Offset(0,lengthOfBar), radius: Radius.circular(radius), clockwise: false);


    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}