import 'package:flutter/foundation.dart';
import 'package:vastermind/models/group_model.dart';
import 'package:vastermind/models/user_model.dart';

class UserData extends ChangeNotifier{
  String currentUserId;
  String userGroupId;
  User currUser;
  Group currGroup;


  void updateUseretails(User user){
    currUser =user;
    notifyListeners();
  }

  void updateGroupDetails(Group group){
    userGroupId = group.id;
    currGroup = group;

    User newUser = currUser;
    newUser.groupId = group.id;
    currUser = newUser;
    notifyListeners();
  }
}