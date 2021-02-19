import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/group_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/screens/accountability/message_screen.dart';
import 'package:vastermind/screens/profileAndHome/profile_screen.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/functions.dart';
import 'package:vastermind/utilities/widgets.dart';

import '../../utilities/constants.dart';

class CommunityScreen extends StatefulWidget {
  static final String id = "community_screen";

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  bool displayFilter = true;

  TextEditingController _searchController = TextEditingController();
  Future<QuerySnapshot> _usersSearchByName;
  Future<QuerySnapshot> _usersSearchById;
  QuerySnapshot _usersConnections;
  QuerySnapshot _usersFollowers;

  QuerySnapshot _usersFollowing;

  List<Group> _groups;

  TabController _Tabcontroller;
  int _selectedIndex = 0;

  FocusNode _focus = new FocusNode();

  List<Widget> list = [
    Tab(text: "User"),
    Tab(text: "Groups"),
  ];

  @override
  void initState() {
    super.initState();
    _Tabcontroller = TabController(length: list.length, vsync: this);

    _focus.requestFocus();
    _focus.addListener(_onFocusChange);
    _Tabcontroller.addListener(() {
      setState(() {
        _selectedIndex = _Tabcontroller.index;
      });
      print("Selected Index: " + _Tabcontroller.index.toString());
    });
  }

  _clearSearch() {
    _searchController.clear();
    setState(() {
      _usersSearchById = null;
      _usersSearchByName = null;
      _groups = null;
      _filtersUsers = "";
    });
  }

  defaultTextAppBar() {
    return Text(
      "People",
      style: TextStyle(color: lightBlue),
    );
  }

  SearchFunctionAppBar() {
    return TextField(
      controller: _searchController,
      focusNode: _focus,
      enableSuggestions: false,
      style: TextStyle(color: grey, fontSize: midSizeText),
      cursorColor: lightBlue,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: -17),
        filled: true,
        labelStyle: TextStyle(color: grey, fontSize: midSizeText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        hintText: _Tabcontroller.index == 0 ? "Search User" : "Search Groups",
        hintStyle: TextStyle(color: grey, fontSize: midSizeText),
        prefixIcon: Icon(
          Icons.search,
          size: 30,
          color: lightBlue,
        ),
        suffix: IconButton(
          icon: Icon(
            Icons.clear,
            color: lightBlue,
          ),
          onPressed: () {
            _clearSearch();
            FocusScope.of(context).unfocus();
          },
        ),
      ),
      onSubmitted: (input) async {
        if (_Tabcontroller.index == 0) {
          if (_filtersUsers.isEmpty) {
          } else if (_filtersUsers == "Connections") {
            _usersConnections = await DatabaseService.displayConnections(
                Provider.of<UserData>(context, listen: false).currentUserId);
            setState(() {
              _usersConnections;
            });
          } else if (_filtersUsers == "Followers") {
            _usersFollowers = await DatabaseService.displayFollowers(
                Provider.of<UserData>(context, listen: false).currentUserId);
            setState(() {
              _usersFollowers;
            });
          } else if (_filtersUsers == "Following") {
            _usersFollowing = await DatabaseService.displayFollowings(
                Provider.of<UserData>(context, listen: false).currentUserId);
            setState(() {
              _usersFollowing;
            });
            print("?????following????");
          }

          if (input.length == 0) {
            //do nothing

          } else {
            setState(() {
              _usersSearchById = DatabaseService.searchUsersById(input);
              _usersSearchByName = DatabaseService.searchUsersByFullName(input);
            });
          }
        }
        if (_Tabcontroller.index == 1) {
          if (input.length == 0 && _filtersGroups.isEmpty) {
            setState(() {
              _groups = _groups;
            });
            //do nothing
          } else if (input.length == 0 && _filtersGroups.isNotEmpty) {
            _groups =
                await DatabaseService.searchGroupByFilters(_filtersGroups);
            setState(() {
              _groups = _groups;
            });
            //search by filters
          } else if (input.length > 0 && _filtersGroups.isEmpty) {
            _groups = await DatabaseService.searchGroupByName(input);
            setState(() {
              _groups = _groups;
            });
            //search by input
          } else if (input.length > 0 && _filtersGroups.isNotEmpty) {
            _groups = await DatabaseService.searchGroupByNameAndFilters(
                input, _filtersGroups);
            setState(() {
              _groups = _groups;
            });

            //search by inputs and then filter
          }
        }
      },
    );
  }

  // requestContainerBody() {
  //   _usersConnections == null ? _usersConnections =  DatabaseService.displayConnections(
  //       Provider.of<UserData>(context).currentUserId):null;
  //   _usersFollowers = DatabaseService.displayFollowers(Provider.of<UserData>(context).currentUserId);
  // }

  userSearchContainerBody() {
    return Column(
      children: [
        displayFilter
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  height: MediaQuery.of(context).size.height / 14,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: _relationshipType.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      bool contains =
                          _filtersUsers == _relationshipType[index].name;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          backgroundColor: contains ? lightBlue : white,
                          padding: EdgeInsets.all(2.0),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: contains ? lightBlue : grey,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          avatar: CircleAvatar(
                            backgroundColor: contains ? greyLight : white,
                            child: Icon(
                              _relationshipType[index].icon,
                              color: contains ? white : grey,
                            ),
                          ),
                          label: Text(
                            _relationshipType[index].name,
                            style: TextStyle(color: contains ? white : grey),
                          ),
                          selected: contains,
                          selectedColor: lightBlue,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _filtersUsers = _relationshipType[index].name;
                              } else {
                                _filtersUsers = "";
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            : SizedBox.shrink(),
        Expanded(
            child: ((_usersSearchByName == null || _usersSearchById == null) &&
                    _filtersUsers.isEmpty)
                ? Center(
                    child: Text(
                      "Search for user or choose relationship ",
                      style: TextStyle(color: grey, fontSize: smallSizeText),
                    ),
                  )
                : FutureBuilder(
                    future: Future.wait([_usersSearchById, _usersSearchByName]),
                    builder: (context, snapshot) {
                      print("_usersSearchById: " + _usersSearchById.toString());
                      print("_usersSearchByName: " +
                          _usersSearchByName.toString());
                      print(_filtersUsers);
                      print("sd");
                      List filteredSearchList = [];

                      if ((snapshot.data == null ||
                              snapshot.data[0] == null ||
                              snapshot.data[1] == null) &&
                          _relationshipType.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.data != null && snapshot.data.length > 0) {
                          QuerySnapshot snapshotOne = snapshot.data[0];
                          QuerySnapshot snapshotTwo = snapshot.data[1];

                          if (snapshotOne.documents.length == 0 &&
                              snapshotTwo.documents.length == 0) {
                            return Center(
                                child:
                                    Text("No users found, Please try again"));
                          }

                          var listOneSnap = snapshotOne.documents.toList();
                          var listTwoSnap = snapshotTwo.documents.toList();
                          var listMain = List();
                          var listTwo = List();

                          for (DocumentSnapshot user in listOneSnap) {
                            User currUser = User.fromDoc(user);
                            listMain.add(currUser);
                          }

                          for (DocumentSnapshot user in listTwoSnap) {
                            User currUser = User.fromDoc(user);
                            listTwo.add(currUser);
                          }

                          listMain.addAll(listTwo);

                          Map<String, User> mp = {};
                          for (User user in listMain) {
                            mp[user.id] = user;
                          }

                          filteredSearchList = mp.values.toList();
                        }

                        print(1.2.toString());

                        QuerySnapshot currQuerySnap;
                        List currQueryList = [];

                        print("relationship type: " + _filtersUsers);

                        if (_filtersUsers == "Connections") {
                          print("perfecto 1");
                          currQuerySnap = _usersConnections;
                        } else if (_filtersUsers == "Followers") {
                          print("perfecto 2");
                          currQuerySnap = _usersFollowers;
                        } else if (_filtersUsers == "Following") {
                          print("perfecto 3");
                          currQuerySnap = _usersFollowing;
                        }

                        if (currQuerySnap != null) {
                          for (DocumentSnapshot docc
                              in currQuerySnap.documents) {
                            User user = User.fromDoc(docc);
                            currQueryList.add(user);
                          }
                        }

                        List finalList = [];

                        print("search user screen funct");
                        print(currQueryList.isEmpty);
                        print(filteredSearchList.isEmpty);

                        if (currQueryList.isEmpty &&
                            filteredSearchList.isEmpty) {
                        } else if (currQueryList.isEmpty &&
                            filteredSearchList.isNotEmpty) {
                          finalList = filteredSearchList;
                          print("0--");
                        } else if (currQueryList.isNotEmpty &&
                            filteredSearchList.isEmpty) {
                          print("1--");
                          finalList = currQueryList;
                        } else if (currQueryList.isNotEmpty &&
                            filteredSearchList.isNotEmpty) {
                          Map<String, User> mp2 = {};
                          for (User userOuter in filteredSearchList) {
                            for (User userInner in currQueryList) {
                              if (userInner.id == userOuter.id) {
                                mp2[userInner.id] = userOuter;
                              }
                            }
                          }

                          finalList = mp2.values.toList();
                        }

                        return ListView.builder(
                          itemCount: finalList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RepeatingFunctions.buildUserTile(
                                user: finalList[index],
                                context: context,
                                currentUserId: Provider.of<UserData>(context)
                                    .currentUserId);
                          },
                        );
                      }
                    },
                  ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
        backgroundColor: white,
        title: SearchFunctionAppBar(),
        bottom: TabBar(
            onTap: (index) => _selectedIndex,
            controller: _Tabcontroller,
            unselectedLabelColor: grey,
            labelColor: lightBlue,
            tabs: list),
      ),
      body: TabBarView(
        controller: _Tabcontroller,
        children: [userSearchContainerBody(), groupSearchContainerBody()],
      ),
    );
  }

  List<String> _filtersGroups = <String>[];
  List<GroupCategoryWidget> _categoryWidgets = <GroupCategoryWidget>[
    GroupCategoryWidget(name: 'Hustle & Work', icon: Icons.work_rounded),
    GroupCategoryWidget(
        name: 'Health & Fitness', icon: Icons.directions_run_rounded),
    GroupCategoryWidget(name: 'Relationships', icon: Icons.people_alt_rounded),
  ];

  String _filtersUsers = "";
  List<GroupCategoryWidget> _relationshipType = <GroupCategoryWidget>[
    GroupCategoryWidget(name: 'Following', icon: Icons.person_rounded),
    GroupCategoryWidget(name: 'Followers', icon: Icons.person_rounded),
    GroupCategoryWidget(name: 'Connections', icon: Icons.person_rounded),
  ];

  void _onFocusChange() {
    print("focus changed");
    _focus.hasFocus
        ? setState(() {
            displayFilter = true;
          })
        : setState(() {
            displayFilter = false;
          });
  }

  groupSearchContainerBody() {
    return Column(
      children: [
        displayFilter
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  height: MediaQuery.of(context).size.height / 14,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: _categoryWidgets.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      bool contains =
                          _filtersGroups.contains(_categoryWidgets[index].name);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          backgroundColor: contains ? lightBlue : white,
                          padding: EdgeInsets.all(2.0),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: contains ? lightBlue : grey,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          avatar: CircleAvatar(
                            backgroundColor: contains ? greyLight : white,
                            child: Icon(
                              _categoryWidgets[index].icon,
                              color: contains ? white : grey,
                            ),
                          ),
                          label: Text(
                            _categoryWidgets[index].name,
                            style: TextStyle(color: contains ? white : grey),
                          ),
                          selected: contains,
                          selectedColor: lightBlue,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _filtersGroups
                                    .add(_categoryWidgets[index].name);
                              } else {
                                _filtersGroups.removeWhere((String name) {
                                  return name == _categoryWidgets[index].name;
                                });
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            : SizedBox.shrink(),
        Expanded(
            child: _groups == null
                ? Center(
                    child: Text(
                    "Search Groups or choose from category",
                    style: TextStyle(color: grey, fontSize: smallSizeText),
                  ))
                : _groups.length == 0
                    ? Center(
                        child: Text(
                        "No results",
                        style: TextStyle(color: grey, fontSize: smallSizeText),
                      ))
                    : Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: Text(
                            "press on the group to connect with group leader. You will need to connect with group leader and get inivited to join the group",
                            style:
                                TextStyle(color: grey, fontSize: smallSizeText),
                          ),
                        ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ProfileScreen(userId: _groups[index].leader,currentuserId: Provider.of<UserData>(context).currentUserId,)));
                      },
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.people_rounded,
                          size: 20,
                        ),
                        backgroundColor: greyLight,
                        foregroundColor: white,
                      ),
                      title: Text(
                        _groups[index].groupName.toLowerCase(),
                        style: TextStyle(
                            color: lightBlue, fontSize: midSizeText),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                          children: [
                            Text(
                              _groups[index].category,
                              style: TextStyle(
                                  color: grey, fontSize: smallSizeText),
                              overflow: TextOverflow.ellipsis,
                            ),

                          ]
                      ),
                      trailing: Text(
                        _groups[index].members.length.toString() +
                            " member/s",
                        style: TextStyle(
                            color: grey, fontSize: smallSizeText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                      ]))
      ],
    );
  }
}

class GroupCategoryWidget {
  const GroupCategoryWidget({this.name, this.icon});

  final String name;
  final IconData icon;
}
