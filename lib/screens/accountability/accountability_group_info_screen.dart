import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/group_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/reusable_card.dart';
import 'package:vastermind/utilities/widgets.dart';

import 'accountability_log_screen.dart';
import 'create_group_screen.dart';

class AccountabilityGroupInfoScreen extends StatefulWidget {

  @required Group group;

  AccountabilityGroupInfoScreen({this.group});

  @override
  _AccountabilityGroupInfoScreenState createState() => _AccountabilityGroupInfoScreenState();
}

class _AccountabilityGroupInfoScreenState extends State<AccountabilityGroupInfoScreen> {

  @override
  void initState() {
    super.initState();
    getMembersFutures();
  }

  getMembersFutures(){
    for (String member in widget.group.members){
      futureUserMembers.add(DatabaseService.getUserDetails(member).then((value) => User.fromDoc(value)));
    }

  }


  List<Future<User>> futureUserMembers = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(futureUserMembers),
      builder: (context, snapshot){
        return Scaffold(
          backgroundColor: greyLight,
          appBar: SecondaryAppBar(
            title: "Group info",
          ),
          body: snapshot.hasData ? SafeArea(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child:  Row(
                        children: [


                          Expanded(

                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: FlatButton(
                                    color: white,
                                    textColor: grey,
                                    onPressed: (){
                                      //DatabaseService.createGroup();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  UpdateAccountabilityProgressScreen(userId: Provider.of<UserData>(context).currentUserId,group: Provider.of<UserData>(context).currGroup,)));
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.history_rounded, color: grey,size: 27,),
                                        SizedBox(width:10 ,),
                                        Text("History", style: TextStyle(color: grey, fontSize: midSizeText),),
                                      ],),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                              )

                          ),



                          Expanded(
                              child: Padding(
                                padding:    const EdgeInsets.symmetric(horizontal: 8),
                                child: FlatButton(
                                    color: white,
                                    textColor: grey,
                                    onPressed: () async {
                                      await DatabaseService.deleteAllLogs(
                                          Provider.of<UserData>(context, listen: false)
                                              .currentUserId,
                                          Provider.of<UserData>(context, listen: false)
                                              .userGroupId);
                                      setState(() {});
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.clear_rounded, color: Colors.red,size: 27,),
                                        SizedBox(width:5 ,),
                                        Text("Clear Logs", style: TextStyle(color: Colors.red, fontSize: midSizeText),),
                                      ],),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                              )

                          ),
                        ],
                      ),

                    ),
                    Expanded(
                      flex: 8,
                      child: ReusableCard(color: white,cardChild: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Basic Info", style: TextStyle(fontSize: midSizeText, color: lightBlue),),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("📝 Group Name: " + widget.group.groupName, style: TextStyle(color: grey, fontSize: smallSizeText),),
                                              Text("📝 Group Description: " + widget.group.groupDescription, style: TextStyle(color: grey, fontSize: smallSizeText),),
                                              Text("📌 Group Category: " + widget.group.category, style: TextStyle(color: grey, fontSize: smallSizeText),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),),
                    ),
                    Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          Expanded(
                            child: ReusableCard(color: white,cardChild: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Key Actions", style: TextStyle(fontSize: midSizeText, color: lightBlue),),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("✔️ Action 1: "+ widget.group.actionOneName, style: TextStyle(color: grey, fontSize: smallSizeText),),
                                                    Text("✔️ Action 2: "+widget.group.actionTwoName, style: TextStyle(color: grey, fontSize: smallSizeText),),
                                                    Text("✔️ Action 3: "+widget.group.actionThreeName, style: TextStyle(color: grey, fontSize: smallSizeText),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),),
                          ),



                          Expanded(
                            child: ReusableCard(color: white,cardChild: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("More Details", style: TextStyle(fontSize: midSizeText, color: lightBlue),),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("📅 start: " + DateFormat('MMM d y').format(widget.group.groupCreated.toDate()).toString(), style: TextStyle(color: grey, fontSize: smallSizeText),),
                                                    Text("📅 end: " + DateFormat('MMM d y').format(widget.group.groupEndDate.toDate()).toString(), style: TextStyle(color: grey, fontSize: smallSizeText),),
                                                    Text("📅 log every: " +widget.group.progressLogFrequencyInDays.toString() + " day/s", style: TextStyle(color: grey, fontSize: smallSizeText),),
                                                    Text("🏆 success target: " +widget.group.sucessTarget.toString() + "%", style: TextStyle(color: grey, fontSize: smallSizeText),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),),
                          ),
                        ]
                      ),
                    ),

                    Expanded(
                      flex: 8,
                      child: ReusableCard(color: white, cardChild: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Members", style: TextStyle(fontSize: midSizeText, color: lightBlue),),
                          Container(
                            height: MediaQuery.of(context).size.height/8,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: widget.group.members.length,
                                itemBuilder: (BuildContext context, int index) {
                                  User currUser =  snapshot.data[index];

                                  return GroupAddTile(
                                    editable: false,
                                    user: currUser,
                                    leaderUserId: widget.group.leader,
                                    context: context,
                                    currentUserId:
                                    Provider
                                        .of<UserData>(context)
                                        .currentUserId,
                                    groupMembers: widget.group.members,
                                  );
                                }),
                          ),
                        ],
                      ),),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: FilledSecondaryButton(
                            title: "Create New Group",
                            color: lightBlue,
                            top: 10,
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
                      ),
                    )




                  ],
                ),
              ),
            ),
          ) : Center(child: CircularProgressIndicator())
        );
      }
    );
  }
}
