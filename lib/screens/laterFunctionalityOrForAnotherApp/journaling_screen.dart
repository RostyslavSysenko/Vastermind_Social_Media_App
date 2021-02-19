

import 'package:flutter/material.dart';
import 'package:vastermind/utilities/widgets.dart';

class JournalingScreen extends StatefulWidget {
  static final String id = "journaling_screen";
  @override
  _JournalingScreenState createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: "Journaling"),
    );
  }
}
