import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/group_member_score_tile_model.dart';
import 'package:vastermind/models/group_model.dart';
import 'package:vastermind/models/task_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/screens/accountability/BomBom.dart';
import 'package:vastermind/screens/accountability/accountability_group_info_screen.dart';
import 'package:vastermind/screens/community/community_screen.dart';
import 'package:vastermind/screens/profileAndHome/edit_profile_screen.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/functions.dart';
import 'package:vastermind/utilities/widgets.dart';

import 'accountability_group_settings_screen.dart';
import 'accountability_log_screen.dart';
import 'add_accountability_log_screen.dart';
import 'message_screen.dart';

class AccountabilityDashboardScreen extends StatefulWidget {
  static final String id = "accountability_dashboard_screen";

  @override
  _AccountabilityDashboardScreenState createState() =>
      _AccountabilityDashboardScreenState();
}

class _AccountabilityDashboardScreenState
    extends State<AccountabilityDashboardScreen> with TickerProviderStateMixin {




  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.MyGroup;
    screenView = MyHome();
    super.initState();

    DatabaseService.getUserDetails(
        Provider.of<UserData>(context, listen: false).currentUserId).then((value) {
      User user = User.fromDoc(value);
      Provider.of<UserData>(context, listen: false).currUser = user;
    });

  }






  void changeIndex(DrawerIndex drawerIndexdata, context) {
    if (drawerIndex != drawerIndexdata) {

      print("2");

      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.MyGroup) {
        setState(() {
          screenView = MyHome();
          print("2.1");
        });
      } else if (drawerIndex == DrawerIndex.Community) {
        setState(() {
          screenView = CommunityScreen();
          print("2.2");
        });
      } else if (drawerIndex == DrawerIndex.Profile) {

        print("2.3.0.1");

        screenView = EditProfileScreen();

        print("2.3.0.2");

        setState(() {
          print("2.3.1");
          screenView = screenView;

          print(screenView);
          print("2.3.2");
        });
      }
    }
  }











  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body:           DrawerUserController(
        screenIndex: drawerIndex,
        drawerWidth: MediaQuery.of(context).size.width * 0.75,
        onDrawerCall: (DrawerIndex drawerIndexdata) {

          changeIndex(drawerIndexdata, drawerIndex,);
          //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
        },
        screenView: screenView,
        //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
      ),

    );

  }
}






class MyHome extends StatefulWidget {

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with TickerProviderStateMixin  {






  TabController tabController;
  int _selectedIndex = 1;
  FocusNode focus = FocusNode();

  List<Widget> list = [
    Tab(text: "Community"),
    //Tab(text: "In Requests"),
    Tab(text: "Goals"),
  ];

  List<Task> logsMy = [];


  List<GroupMemberScoreTileModel> _allScoreTilesData = [];
  List <User> members;
  List<Task> logs;


  _getLeaderBoardList(BuildContext context) async {

    print("2");


    List<GroupMemberScoreTileModel> allScoreTilesData = [];

    List members =  Provider.of<UserData>(context, listen: false).currGroup.members;

    //get total score and member details for each member

    List<Future<List<Task>>> membersLogsPromises = List();
    List<List<Task>> membersLogs = List();

    List<Future<User>> membersDataPromises = List();
    List<User> membersData= List();

    print("5");

    //creating lists of promises
    for(int idx = 0; idx < members.length; idx++){
      print("members length" + members.length.toString());
      //step 2 getting row member details
      membersLogsPromises.add(DatabaseService.getLogs(members[idx],Provider.of<UserData>(context, listen: false).userGroupId).then((value){

        List<DocumentSnapshot> logsDocs = value.documents;
        List<Task> logs = [];

        for (var logDoc in logsDocs) {
          Task log = Task.fromDoc(logDoc);
          logs.add(log);
        }
        return logs;
      }));
      membersDataPromises.add(DatabaseService.getUserDetails(members[idx]).then((value) => User.fromDoc(value)));
    }

    print("6");

    //executing those promises
    membersLogs = await Future.wait(membersLogsPromises);
    membersData = await Future.wait(membersDataPromises);

    //creating tileObjects

    for(int idx = 0; idx < members.length; idx++){
      String memberName = membersData[idx].fullName;
      String memberProfileImageUrl = membersData[idx].profileImageUrl;
      List currMembersLogs = membersLogs[idx];
      int memberSuccessScore = RepeatingFunctions.getSuccessScore(
          currMembersLogs, "non-accountability");

      if (Provider.of<UserData>(context, listen: false).currUser.id == membersData[idx].id){
        if(currMembersLogs == null){
          logsMy = [];
        } else {
          logsMy = currMembersLogs;
        }

      }

      GroupMemberScoreTileModel newTile = GroupMemberScoreTileModel(
          profileImageUrl: memberProfileImageUrl,
          fullName: memberName,
          logNum: currMembersLogs.length,
          sucessScore: memberSuccessScore);

      allScoreTilesData.add(newTile);
    }

    print("7");

    allScoreTilesData.sort((a, b){
      return a.sucessScore.compareTo(b.sucessScore);
    });
    allScoreTilesData = List.from(allScoreTilesData.reversed);


    _allScoreTilesData = allScoreTilesData;

    print("8");
    print(_allScoreTilesData);

    return _allScoreTilesData;


  }






  _getGroup()async {

    print("s");

    DocumentSnapshot userSnap = await DatabaseService.getUserDetails(
        Provider.of<UserData>(context, listen: false).currentUserId);

    User user = User.fromDoc(userSnap);
    Provider.of<UserData>(context, listen: false).currUser = user;
    Provider.of<UserData>(context, listen: false).currentUserId = user.id;

    print("ss");
    DocumentSnapshot groupSnap;

    groupSnap = await groupsRef.document(Provider.of<UserData>(context, listen: false).currUser.groupId).get();

    print("sss");
    Group group = Group.fromDoc(groupSnap);

    print("ssss");
    Provider.of<UserData>(context, listen: false ).currGroup = group;
    Provider.of<UserData>(context, listen: false).userGroupId = group.id;

    return await _getLeaderBoardList(context);

  }




  initState(){
    super.initState();
    tabController = TabController(length: list.length, vsync: this,initialIndex: _selectedIndex);
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
      });


    });
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getGroup(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Scaffold(body: Center(child: CircularProgressIndicator(),),);
        } else {

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: white,
              title: Text(
                "Hello, " + Provider.of<UserData>(context).currUser.fullName.split(" ")[0] ,
                style: TextStyle(color: lightBlue, fontSize: midSizeText),
              ),
              bottom: TabBar(
                  onTap: (index){
                    _selectedIndex = index;
                    FocusScope.of(context).requestFocus(new FocusNode());

                  },

                  controller: tabController,
                  unselectedLabelColor: grey,
                  labelColor: lightBlue,
                  tabs: list),
              actions: [
                Provider.of<UserData>(context).currentUserId == Provider.of<UserData>(context).currGroup.leader ? Ink(
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: largeSizeText,
                    ),
                    color: lightBlue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  AccountabilityGroupSettingsScreen()));
                    },
                  ),
                ) : SizedBox.shrink(),
              ],



            ),

            body: TabBarView(
              controller: tabController,
              children: [
                ChatScreen(groupId: Provider.of<UserData>(context).userGroupId, focus: focus,),
                if (_allScoreTilesData != null && _allScoreTilesData.length > 0 && logsMy != null) Scaffold(
                  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
                  bottomNavigationBar: Container(
                    height: MediaQuery.of(context).size.height/12,
                    child: BottomAppBar(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          left: 30,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            (logsMy.length == 1) ? Text(
                              "${logsMy.length} log ${RepeatingFunctions.getSuccessScore(logsMy, "accountability")} | ${Provider.of<UserData>(context).currGroup.groupEndDate.toDate().difference(DateTime.now()).inDays} days to go",
                              style: TextStyle(color: lightBlue, fontSize: smallSizeText),
                            ) : (logsMy.length > 1) ? Text(
                              "${logsMy.length} logs ${RepeatingFunctions.getSuccessScore(logsMy, "accountability")} | ${Provider.of<UserData>(context).currGroup.groupEndDate.toDate().difference(DateTime.now()).inDays} days to go",
                              style: TextStyle(color: lightBlue, fontSize: smallSizeText),
                            ) : Text(
                              "${logsMy.length} logs | ${Provider.of<UserData>(context).currGroup.groupEndDate.toDate().difference(DateTime.now()).inDays} days to go",
                              style: TextStyle(color: lightBlue, fontSize: smallSizeText),
                            )

                          ],
                        ),
                      ),
                      shape: CircularNotchedRectangle(),
                      // color: ,
                    ),

                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10.0))),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => AddAccountabilityEntryScreen(actionItemOneName: Provider.of<UserData>(context).currGroup.actionOneName,actionItemTwoName: Provider.of<UserData>(context).currGroup.actionTwoName,
                            actionItemThreeName: Provider.of<UserData>(context).currGroup.actionThreeName,








                            callbackToLogScreen:
                                  (scoreOne, scoreTwo, scoreThree, notes, date, totalScore) async {
                                 double _actionItemOneScore = scoreOne;
                                double _actionItemTwoScore = scoreTwo;
                                double _actionItemThreeScore = scoreThree;
                                String _note = notes;
                                DateTime _date = date;
                                double _totalScore = totalScore;

                                Task newTask = Task(
                                    date: _date,
                                    progressScoreOne: _actionItemOneScore,
                                    progressScoreTwo: _actionItemTwoScore,
                                    progressScoreThree: _actionItemThreeScore,
                                    note: _note,
                                    totalScore: _totalScore);

                                Task repeatedLog;
                                bool repeated = false;



                                logsMy.forEach((log) {
                                  if (newTask.date.month == log.date.month &&
                                      newTask.date.day == log.date.day &&
                                      newTask.date.year == log.date.year) {
                                    repeated = true;
                                    repeatedLog = log;
                                  }
                                });
                                if(repeated){

                                  await DatabaseService.replaceLog(
                                      newTask, Provider.of<UserData>(context, listen: false).currGroup.id, Provider.of<UserData>(context, listen: false).currentUserId);
                                } else {
                                  await DatabaseService.createLog(
                                      newTask, Provider.of<UserData>(context, listen: false).currGroup.id, Provider.of<UserData>(context, listen: false).currentUserId);
                                }

                                 await _getLeaderBoardList;
                                setState(() {
                                  _allScoreTilesData;
                                });



                                Navigator.pop(context);
                              },













                          ));
                    },
                    backgroundColor: lightBlue,
                    child: Icon(
                      Icons.add,
                      color: white,
                    ),
                  ),
                  body: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Container(width: MediaQuery.of(context).size.width/10,),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Name", style: TextStyle(color: lightBlue, fontSize: smallSizeText),),
                                      Text("Score", style: TextStyle(color: lightBlue, fontSize: smallSizeText)),
                                      Text("Logs", style: TextStyle(color: lightBlue, fontSize: smallSizeText)),
                                      Text("Rank", style: TextStyle(color: lightBlue, fontSize: smallSizeText)),
                                    ],
                                  ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) => Divider(),
                          itemCount: _allScoreTilesData.length,
                          itemBuilder: (context, index) {
                            GroupMemberScoreTileModel currTileDataObj = _allScoreTilesData[index];


                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: greyLight,
                                backgroundImage: currTileDataObj.profileImageUrl.isEmpty
                                    ? AssetImage('assets/images/profileImage.png')
                                    : CachedNetworkImageProvider(
                                    currTileDataObj.profileImageUrl),
                              ),
                              title: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      child: Center(child: Text(currTileDataObj.fullName, style: TextStyle(color: lightBlue, fontSize: smallSizeText),))),
                                  Expanded(
                                      flex: 1,
                                      child: Center(child: Text(currTileDataObj.sucessScore.toString() + "%", style: TextStyle(color: lightBlue, fontSize: smallSizeText),))),
                                  Expanded(
                                      flex: 1,
                                      child: Center(child: Text(currTileDataObj.logNum.toString(), style: TextStyle(color: lightBlue, fontSize: smallSizeText),))),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text((index +1).toString(), style: TextStyle(color: lightBlue, fontSize: smallSizeText),),
                                          (index +1) <= 3
                                              ? Icon(
                                            Icons.emoji_events_rounded,
                                            size: midSizeText,
                                            color: lightBlue,
                                          ) : SizedBox(),
                                        ],
                                      ),

                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ) else Center(child: CircularProgressIndicator()),
              ],
            ),
          );



        }

      }

    );
  }
}



