import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/functions.dart';
import 'package:vastermind/utilities/widgets.dart';

class ConnectionsScreen extends StatefulWidget {
  static String id = "connections_screen";
  String userId;

  ConnectionsScreen({this.userId});

  @override
  _ConnectionsScreenState createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {

  Future<QuerySnapshot> _usersConnections;

  @override
  Widget build(BuildContext context) {
    _usersConnections =  DatabaseService.displayConnections(
        widget.userId);


      return _usersConnections == null
          ? Center(
        child: Text("Please connect to the internet"),
      )
          : Scaffold(
        appBar: SecondaryAppBar(
          title: "Connections",
        ),
            body: FutureBuilder(
        future: _usersConnections,
        builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print("doesnt have data");
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data.documents.length == 0) {
              print("length 0");
              return Center(child: Text("Currently no connections", style: TextStyle(color: grey, fontSize: smallSizeText),));
            }
            else return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                User user = User.fromDoc(snapshot.data.documents[index]);
                return RepeatingFunctions.buildUserTile(
                    user: user,
                    context: context,
                    currentUserId:
                    Provider.of<UserData>(context).currentUserId);
              },
            );
        },
      ),
          );

  }
}
