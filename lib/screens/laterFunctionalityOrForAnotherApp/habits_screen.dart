import 'package:flutter/material.dart';
import 'package:vastermind/utilities/widgets.dart';

class HabitsScreen extends StatefulWidget {
  String userId;
  HabitsScreen({this.userId});

  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(title: "Habits",)

    );
  }
}
