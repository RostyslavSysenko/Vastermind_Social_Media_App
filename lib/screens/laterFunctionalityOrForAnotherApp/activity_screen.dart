

import 'package:flutter/material.dart';
import 'package:vastermind/services/AuthService.dart';
import 'package:vastermind/utilities/widgets.dart';

import '../../utilities/constants.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefault,
      body: Center(child: FilledSecondaryButton(title: "logout", function: (){ AuthService.logout(context);
          Navigator.of(context).pop();}, color: black,top: 10,)),);
  }
}
