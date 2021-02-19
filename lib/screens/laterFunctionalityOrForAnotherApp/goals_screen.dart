import 'package:flutter/material.dart';
import 'package:vastermind/utilities/widgets.dart';

class GoalsScreen extends StatefulWidget {
  String userId;
  GoalsScreen({this.userId});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(title: "Goals",)

    );
  }
}
