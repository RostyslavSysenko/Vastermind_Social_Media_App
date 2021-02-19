import 'package:flutter/material.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/widgets.dart';

class SummaryScreen extends StatefulWidget {
  String userId;
  SummaryScreen({this.userId});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Post functionality coming soon ",style: TextStyle(color: grey, fontSize: smallSizeText),),),
    );
  }
}
