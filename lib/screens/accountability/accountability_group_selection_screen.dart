import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/screens/accountability/create_group_screen.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/widgets.dart';

import 'accountability_dashboard_screen.dart';

class AccountabilityGroupSelectionScreen extends StatefulWidget {
  static final String id = "accountability_group_selection_screen";
  @override
  _AccountabilityGroupSelectionScreenState createState() => _AccountabilityGroupSelectionScreenState();
}

class _AccountabilityGroupSelectionScreenState extends State<AccountabilityGroupSelectionScreen> {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: "Groups"),
      body: Center(
        child: Column(

          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text("Currently you can only enroll in one group, thus is you enroll or create a new group, you will leave your previous group", style: TextStyle(color: grey, fontSize: smallSizeText),),
            ),
            Provider.of<UserData>(context).userGroupId != null && Provider.of<UserData>(context).userGroupId.length > 0 ? FilledSecondaryButton(
              color: lightBlue,
                title: "Go to your group",
                top: 10,
                buttonSize: "big",
                function: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AccountabilityDashboardScreen()));
                }
            ) : SizedBox(),
            FilledSecondaryButton(
                title: "Create New Group",
                color: lightBlue,
                top: 0,
                buttonSize: "big",
                function: (){
                  //DatabaseService.createGroup();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              CreateGroupScreen(
callbackToGroupSelectionScreen: (groupId){
  setState(() {
    Provider.of<UserData>(context, listen: false).userGroupId = groupId;

  });
},
                              )));
                }
            ),
          ],
        ),
      )

    );
  }
}
