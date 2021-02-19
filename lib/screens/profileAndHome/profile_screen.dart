import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/screens/accountability/accountability_group_selection_screen.dart';
import 'package:vastermind/screens/community/profileRelationships/connections_screen.dart';
import 'package:vastermind/screens/community/profileRelationships/followers_screen.dart';
import 'package:vastermind/screens/community/profileRelationships/following_screen.dart';
import 'package:vastermind/screens/accountability/accountability_log_screen.dart';
import 'package:vastermind/screens/community/community_screen.dart';
import 'package:vastermind/screens/accountability/message_screen.dart';
import 'package:vastermind/screens/laterFunctionalityOrForAnotherApp/summary_screen.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/services/AuthService.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/widgets.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String currentuserId;

  ProfileScreen({this.userId, this.currentuserId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User _profileUser;

  bool isFollowing = true;
  bool usersConnected;
  bool privacyAccessGranted = false;
  int _followerCount = 0;
  int _followingCount = 0;
  int _connectionCount = 0;
  double horizontalgeneralPadding = 16;
  double headerVertContainerSizer;

  @override
  void initState() {
    super.initState();
    print("jnj");
    _setUpRelationship();
    _setUpFollowing();
    _setUpFollowers();
    _setUpConnections();
    //getCurrUserDetails();
  }

  // getCurrUserDetails() async {
  //   DocumentSnapshot userDoc = await DatabaseService.getUserDetails(Provider.of<UserData>(context).currentUserId);
  //   User user = User.fromDoc(userDoc);
  //
  //   Provider.of<UserData>(context).numOfConnections = user.numOfConnections;
  //   Provider.of<UserData>(context).numFollowing = user.numFollowing;
  //   Provider.of<UserData>(context).numOfFollowers = user.numOfFollowers;
  //
  //   Provider.of<UserData>(context).fullName = user.fullName;
  //   Provider.of<UserData>(context).profileImageUrl = user.profileImageUrl;
  //   Provider.of<UserData>(context).name = user.name;
  //   Provider.of<UserData>(context).userGroupId = user.groupId;
  // }

  _displayMyConnectionsButtons() {
    return FlatButton(
        color: grey.withOpacity(0.2),
        textColor: grey,
        onPressed: _followOrUnfollow,
        child: Text("Disconnect"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }

  _displayButtonsOfUnknown() {
    return FlatButton(
        color: grey.withOpacity(0.2),
        textColor: grey,
        onPressed: _followOrUnfollow,
        child: Text("Connect"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }

  _followOrUnfollow() {
    setState(() {
      if (isFollowing) {
        _unfollow();
      } else {
        _follow();
      }
    });
  }

  _unfollow() async {
    await DatabaseService.unFollowUser(
        userId: widget.userId, currentUserId: widget.currentuserId);

    setState(() {
      _followerCount--;
      isFollowing = false;
    });

    bool connectionBefore = usersConnected;
    await _setUpRelationship();

    bool connectionAfter = usersConnected;

    if (connectionBefore != connectionAfter) {
      setState(() {
        _connectionCount--;
      });
    }
  }

  _follow() async {
    await DatabaseService.followUser(
        userId: widget.userId, currentUserId: widget.currentuserId);

    setState(() {
      _followerCount++;
      isFollowing = true;
    });

    bool connectionBefore = usersConnected;
    await _setUpRelationship();

    bool connectionAfter = usersConnected;

    if (connectionBefore != connectionAfter) {
      setState(() {
        _connectionCount++;
      });
    }
  }

  _setUpRelationship() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentuserId,
      userId: widget.userId,
    );

    usersConnected = await DatabaseService.isConnection(
      currentUserId: widget.currentuserId,
      userId: widget.userId,
    );

    setState(() {
      isFollowing = isFollowingUser;
      privacyAccessGranted = usersConnected || _isMyProfile();
    });
  }

  _isMyProfile() {
    return widget.userId == widget.currentuserId;
  }

  _setUpConnections() async {
    int userConnectionCount =
    await DatabaseService.numConnections(userId: widget.userId);
    setState(() {
      _connectionCount = userConnectionCount;
    });
  }

  _setUpFollowers() async {
    int userFollowerCount =
    await DatabaseService.numFollowers(userId: widget.userId);
    setState(() {
      _followerCount = userFollowerCount;
    });
  }

  _setUpFollowing() async {
    int userFollowingCount =
    await DatabaseService.numFollowing(userId: widget.userId);
    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _displayRequestedConnectionsButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FlatButton(
            color: grey.withOpacity(0.2),
            textColor: grey,
            onPressed: _followOrUnfollow,
            child: Text("Remove Request"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    headerVertContainerSizer = MediaQuery
        .of(context)
        .size
        .height / 7;

    return Scaffold(
        appBar: appBarDefault,
        body: Container(
          color: greyLight,
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.centerLeft,
          //         end: Alignment.centerRight,
          //         colors: [lightBlue, Colors.purple])),
          child: FutureBuilder(
              future: usersRef.document(widget.userId).get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                User user = User.fromDoc(snapshot.data);

                return Column(
                  children: <Widget>[
                    Container(
                      height: headerVertContainerSizer * 1.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalgeneralPadding),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: user.profileImageUrl.isEmpty
                                              ? AssetImage(
                                              'assets/images/profileImage.png')
                                              : CachedNetworkImageProvider(
                                              user.profileImageUrl),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        color: greyLight,
                                      ),
                                      width: (headerVertContainerSizer),
                                      height: (headerVertContainerSizer),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  height: headerVertContainerSizer,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(user.fullName,
                                                    style: TextStyle(
                                                        fontSize: midSizeText,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: black)),
                                                Text("@" + user.name,
                                                    style: TextStyle(
                                                        fontSize: smallSizeText,
                                                        color: grey)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              user.id ==
                                                  Provider
                                                      .of<UserData>(
                                                      context)
                                                      .currentUserId
                                                  ? FlatButton(
                                                  color:
                                                  grey.withOpacity(0.2),
                                                  textColor: grey,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) {
                                                          return EditProfileScreen(

                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Text("Settings", style: TextStyle(fontSize: smallSizeText),),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10))) //if it is me
                                                  : privacyAccessGranted
                                                  ? _displayMyConnectionsButtons()
                                                  : isFollowing
                                                  ? _displayRequestedConnectionsButtons() //requested
                                                  : _displayButtonsOfUnknown()
                                              //unknown
                                              ,
                                            ],
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            ButtonNoFill(
                                              textColor: lightBlue,
                                              textSize: smallSizeText,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 0),
                                              function: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_)
                                                        {
                                                          return FollowersScreen(
                                                            userId: user.id,);
                                                        }


                                                    ) );
                                              },
                                              title: (_followerCount == 0 ||
                                                  _followerCount > 1)
                                                  ? _followerCount.toString() +
                                                  " followers"
                                                  : _followerCount.toString() +
                                                  " follower",
                                            ),
                                            ButtonNoFill(
                                              textColor: lightBlue,
                                              textSize: smallSizeText,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 0),
                                              function: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_)
                                                        {
                                                          return FollowingScreen(
                                                            userId: user.id,);
                                                        }


                                                    ) );
                                              },
                                              title: (_followingCount == 0 ||
                                                  _followingCount > 1)
                                                  ? _followingCount.toString() +
                                                  " follows"
                                                  : _followingCount.toString() +
                                                  " follow",
                                            ),
                                            ButtonNoFill(
                                              function: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_)
                                                        {
                                                          return ConnectionsScreen(
                                                            userId: user.id,);
                                                        }


                                                    ) );
                                              },
                                              textSize: smallSizeText,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 0),
                                              textColor: lightBlue,
                                              title: (_connectionCount == 0 ||
                                                  _connectionCount > 1)
                                                  ? _connectionCount
                                                  .toString() +
                                                  " connections"
                                                  : _connectionCount
                                                  .toString() +
                                                  " connection",
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: privacyAccessGranted
                              ? SummaryScreen(userId: widget.userId)
                              : SizedBox(),
                        ),
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
