import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/functions.dart';
import 'package:vastermind/utilities/widgets.dart';

class FollowersScreen extends StatefulWidget {
  static String id = "followers_screen";
  String userId;

  FollowersScreen({this.userId});

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {

  Future<QuerySnapshot> _usersFollowing;

  @override
  Widget build(BuildContext context) {
    _usersFollowing =  DatabaseService.displayFollowers(
        widget.userId);


    return _usersFollowing == null
        ? Center(
      child: Text("Please connect to the internet"),
    )
        : Scaffold(
      appBar: SecondaryAppBar(
        title: "Followers",
      ),
      body: FutureBuilder(
        future: _usersFollowing,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("doesnt have data");
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data.documents.length == 0) {
            print("length 0");
            return Center(child: Text("Currently no Followers", style: TextStyle(color: grey, fontSize: smallSizeText),));
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
