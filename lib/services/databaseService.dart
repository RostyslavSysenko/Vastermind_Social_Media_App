import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/group_model.dart';
import 'package:vastermind/models/post_model.dart';
import 'package:vastermind/models/task_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/utilities/constants.dart';

class DatabaseService {
  //this method takes the user that we have created locally, then accessses the instance in database with
  //the same user id as the instance we created locally and updates all database info to local info
  static void updateUser(User user) {
    usersRef.document(user.id).updateData({
      'fullName': user.fullName,
      'profileImageUrl': user.profileImageUrl,
    });

    //connectionsRef.document()
  }

  static Future<QuerySnapshot> searchUsersById(String name) {
    Future<QuerySnapshot> users=
        usersRef.where("name", isGreaterThanOrEqualTo: name).limit(2).getDocuments();

    return users;
  }

  static Future<QuerySnapshot> searchUsersByFullName(String name) {
    Future<QuerySnapshot> users =
    usersRef.where("fullName", isGreaterThanOrEqualTo: name).limit(2).getDocuments();

    return users;
  }










  static Future<DocumentSnapshot> getUserDetails (String userId){
    return usersRef.document(userId).get();
  }

  // static Future<DocumentSnapshot> createGroup (User currentUser){
  //   groupsRef.document().collection("groupMembers").document(currentUser.id).setData(
  //       {
  //         'name': currentUser.name,
  //         'fullName': currentUser.fullName,
  //         'profileImageUrl': currentUser.profileImageUrl,
  //       });
  //   usersRef.document(currentUser.id).collection("groups").document();
  //   }

  static Future<DocumentSnapshot> getAllGroupDetails (groupId){
    return groupsRef.document(groupId).get();
  }



  static void createPost(Post post) {
    postsRef.document(post.authorId).collection("usersPosts").add({
      "imageUrl": post.imageUrl,
      "caption": post.caption,
      "likes": post.likes,
      "authorId": post.authorId,
      "timestamp": post.timestamp,
    });
  }



  static getGroupId(String currUserId) async {
    DocumentSnapshot group = await usersRef.document(currUserId).get();
    String groupId = group.data["groupId"];
    return groupId;
  }

  static void followUser({String currentUserId, String userId}) async {
    DocumentSnapshot currentUserDoc =
    await usersRef.document(currentUserId).get();

    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    User currentUser = User.fromDoc(currentUserDoc);
    User user = User.fromDoc(userDoc);


    await followersRef
        .document(user.id)
        .collection("userFollowers")
        .document(currentUser.id)
        .setData({
      'name': currentUser.name,
      'fullName': currentUser.fullName,
      'profileImageUrl': currentUser.profileImageUrl,
    });

    await followingRef
        .document(currentUser.id)
        .collection("userFollowing")
        .document(user.id)
        .setData({
      'name': user.name,
      'fullName': user.fullName,
      'profileImageUrl': user.profileImageUrl,
    });



    int numOfConnectionsUser;
    int numOfConnectionsCurrentUser;

    bool connected =
        await isConnection(userId: userId, currentUserId: currentUserId);



    if (connected) {
      numOfConnectionsUser = user.numOfConnections + 1;
      numOfConnectionsCurrentUser = currentUser.numOfConnections + 1;

    createConnection(user, currentUser);

    } else {
      numOfConnectionsUser = user.numOfConnections;
      numOfConnectionsCurrentUser = currentUser.numOfConnections;
    }

    usersRef.document(userId).updateData({
      "numOfConnections": numOfConnectionsUser,
      "numOfFollowers": user.numOfFollowers + 1,
    });

    usersRef.document(currentUserId).updateData({
      "numFollowing": currentUser.numFollowing + 1,
      "numOfConnections": numOfConnectionsCurrentUser,
    });
  }

  static void createConnection(User user, User currentUser){
    connectionsRef
        .document(user.id)
        .collection("userConnections")
        .document(currentUser.id)
        .setData({
      'name': currentUser.name,
      'fullName': currentUser.fullName,
      'profileImageUrl': currentUser.profileImageUrl,
    });

    connectionsRef
        .document(currentUser.id)
        .collection("userConnections")
        .document(user.id)
        .setData({


      'name': user.name,
      'fullName': user.fullName,
      'profileImageUrl': user.profileImageUrl,
    });
  }


  static void unFollowUser({String currentUserId, userId}) async {
    // followingRef
    //     .document(currentUserId)
    //     .collection("userFollowing")
    //     .document(userId)
    //     .delete();

    DocumentSnapshot currentUserDoc =
    await usersRef.document(currentUserId).get();
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    User currentUser = User.fromDoc(currentUserDoc);
    User user = User.fromDoc(userDoc);
    int numOfConnectionsUser;
    int numOfConnectionsCurrentUser;

    bool connected =
    await isConnection(userId: user.id, currentUserId: currentUser.id);

    if (connected){
      numOfConnectionsUser = user.numOfConnections - 1;
      numOfConnectionsCurrentUser = currentUser.numOfConnections - 1;
    } else {
      numOfConnectionsUser = user.numOfConnections;
      numOfConnectionsCurrentUser = currentUser.numOfConnections;
    }


    await followersRef
        .document(userId)
        .collection("userFollowers")
        .document(currentUserId)
        .delete();

    await followingRef
        .document(currentUserId)
        .collection("userFollowing")
        .document(userId)
        .delete();

      connectionsRef
          .document(userId)
          .collection("userConnections")
          .document(currentUserId)
          .delete();

      connectionsRef
          .document(currentUserId)
          .collection("userConnections")
          .document(userId)
          .delete();


    usersRef.document(userId).updateData({
      "numOfConnections": numOfConnectionsUser,
      "numOfFollowers": user.numOfFollowers - 1,
    });

    usersRef.document(currentUserId).updateData({
      "numFollowing": currentUser.numFollowing - 1,
      "numOfConnections": numOfConnectionsCurrentUser,
    });
  }












//when we have curly braces inside the parameter is then named which means that we dont need to set each parameter in order when pas
  //passing parameters to the method and we can just name them instead
  static Future<bool> isFollowingUser(
      {String currentUserId, String userId}) async {
    //document snapshot data type is used because we are only getting a single JSON doc as an output
    DocumentSnapshot followerDoc = await followingRef
        .document(currentUserId)
        .collection("userFollowing")
        .document(userId)
        .get();

    return followerDoc.exists;
  }

  static Future<bool> isBeingFollowedByUser(
      {String currentUserId, String userId}) async {
    //document snapshot data type is used because we are only getting a single JSON doc as an output
    DocumentSnapshot followingDoc = await followersRef
        .document(currentUserId)
        .collection("userFollowers")
        .document(userId)
        .get();
    return followingDoc.exists;
  }

  static Future<bool> isConnection(
      {String currentUserId, String userId}) async {
    bool isFollowing =
        await isFollowingUser(currentUserId: currentUserId, userId: userId);
    bool isBeingFollowed = await isBeingFollowedByUser(
        currentUserId: currentUserId, userId: userId);


    return isFollowing && isBeingFollowed;
  }

  static Future<int> numConnections({String userId}) async {
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    User user = User.fromDoc(userDoc);
    return user.numOfConnections;
  }

  static Future<int> numFollowers({String userId}) async {
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    User user = User.fromDoc(userDoc);
    return user.numOfFollowers;
  }

  static Future<int> numFollowing({String userId}) async {
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    User user = User.fromDoc(userDoc);
    return user.numFollowing;
  }

  static Future<QuerySnapshot> displayConnections(String currentUserId){
    Future<QuerySnapshot> userIdsOfConnections = connectionsRef
        .document(currentUserId)
        .collection("userConnections")
        .getDocuments();

    return userIdsOfConnections;
  }



  static addMember(String groupId, String userId) async {
    List<String> members = List();

    members.add(userId);
    await groupsRef.document(groupId).updateData({
      "members": FieldValue.arrayUnion(members)
    });
    await usersRef.document(userId).updateData({"groupId": groupId});
  }

  static removeMember(String groupId, String userId) async {
    List<String> members = List();

    members.add(userId);
    await groupsRef.document(groupId).updateData({
      "members": FieldValue.arrayRemove(members)
    });
    await usersRef.document(userId).updateData({"groupId": ""});
  }

  static getGroupMembers (String groupId)  {
    Future<DocumentSnapshot> groupInfo = groupsRef.document(groupId).get();
    return groupInfo;
  }

  static Future<QuerySnapshot> getLogs(String userId, String groupId)  {
    Future<QuerySnapshot> snapshotOfLogs = groupsRef.document(groupId).collection("logs").where("userId", isEqualTo: userId).orderBy("date").getDocuments();
    print("boom" + userId.toString());

    return snapshotOfLogs;
  }


  static createLog(Task log, String groupId, String userId){
    groupsRef.document(groupId).collection("logs").document().setData({
      "userId": userId,
    "date": log.date,
    "note": log.note,
    "progressScoreOne": log.progressScoreOne,
    "progressScoreTwo": log.progressScoreTwo,
    "progressScoreThree": log.progressScoreThree,
      "totalScore": log.totalScore
    }
    );
  }

  static void deleteLog(DateTime date, String currentUserId, String groupId) async{

    Timestamp timestamp = Timestamp.fromDate(date);
    var deletedDoc = await groupsRef.document(groupId).collection("logs").where("date", isEqualTo: timestamp).where("userId", isEqualTo: currentUserId).getDocuments();
    String docIdForDeletedDoc = deletedDoc.documents[0].documentID;

    groupsRef.document(groupId).collection("logs").document(docIdForDeletedDoc).delete();
  }

  static void deleteAllLogs(String currentUserId, String userGroupId) async {
    QuerySnapshot deletedDocs = await groupsRef.document(userGroupId).collection("logs").where("userId", isEqualTo: currentUserId).getDocuments();
    deletedDocs.documents.forEach((doc) {groupsRef.document(userGroupId).collection("logs").document(doc.documentID).delete();});

  }


  static void updateGroupSettings(categoryName, itemOneName, itemTwoName, itemThreeName, sucessScore, endDate, String oneSentanceStatement,goalDescription, logFrequencyInDays, groupId, _choiceIndex, progressLogFreuqnecyInDays, progressLogDuration, sessionFreuqencyInDays, sessionDuration) async {

      await groupsRef.document(groupId).updateData({
        //9 things
        "title": oneSentanceStatement.toLowerCase(),
        "description": goalDescription,
        "category": categoryName,
        "actionOneName": itemOneName ,
        "actionTwoName": itemTwoName ,
        "actionThreeName": itemThreeName ,
        "successTarget": sucessScore ,
        "GroupEndDate": endDate ,
        "groupLogFrequencyInDays": logFrequencyInDays,

        "rowChoiceIndex": _choiceIndex,
        "rowProgressLogFrequencyInDays": progressLogFreuqnecyInDays,
        "rowProgressLogDuration": progressLogDuration,
        "rowSessionFrequencyInDays": sessionFreuqencyInDays,
        "rowSessionDuration": sessionDuration,
      });
    }




  static createGroup(String category, String actionOneName, String actionTwoName, String actionThreeName, int sucessTarget, Timestamp groupEndDate, int logGroupFrequencyInDays, String groupName,String groupDescription, String userId, List<String> members, _choiceIndex, progressLogFreuqnecyInDays, progressLogDuration, sessionFreuqencyInDays, sessionDuration) async{

    DocumentReference _docRef = await groupsRef.add({

      //9 things
      "title": groupName.toLowerCase(),
      "description": groupDescription,
      "category": category,
      "actionOneName": actionOneName ,
      "actionTwoName": actionTwoName ,
      "actionThreeName": actionThreeName ,
      "successTarget": sucessTarget ,
      "GroupEndDate": groupEndDate ,
      "groupLogFrequencyInDays": logGroupFrequencyInDays,

      "leader": userId,
      "members": members,
      "groupCreate" : Timestamp.now(),

      "rowChoiceIndex": _choiceIndex,
      "rowProgressLogFrequencyInDays": progressLogFreuqnecyInDays,
      "rowProgressLogDuration": progressLogDuration,
      "rowSessionFrequencyInDays": sessionFreuqencyInDays,
      "rowSessionDuration": sessionDuration,

    });

    await usersRef.document(userId).updateData({"groupId": _docRef.documentID});
    return _docRef.documentID;
  }




  static void replaceLog(Task newTask, String groupId, String userId) async {
    String iD;
    QuerySnapshot docs = await groupsRef.document(groupId).collection("logs").where("userId", isEqualTo: userId).getDocuments();
    docs.documents.forEach((doc) {
      Timestamp stamp = doc.data["date"];
      DateTime date = stamp.toDate();
      if (date.day == newTask.date.day && date.month == newTask.date.month && date.year == newTask.date.year){
         iD = doc.documentID;
      }
    });

    await groupsRef.document(groupId).collection("logs").document(iD).setData({
        "userId": userId,
        "date": newTask.date,
        "note": newTask.note,
        "progressScoreOne": newTask.progressScoreOne,
        "progressScoreTwo": newTask.progressScoreTwo,
        "progressScoreThree": newTask.progressScoreThree,
      "totalScore": newTask.totalScore
    });


  }

  static Future<QuerySnapshot> displayFollowings(String currentUserId) {
    Future<QuerySnapshot> userIdsOfFollowings = followingRef
        .document(currentUserId)
        .collection("userFollowing")
        .getDocuments();

    return userIdsOfFollowings;

  }

  static Future<QuerySnapshot> displayFollowers(String currentUserId){
    Future<QuerySnapshot> userIdsOfFollowers = followersRef
        .document(currentUserId)
        .collection("userFollowers")
        .getDocuments();

    return userIdsOfFollowers;
  }

  static Future<List<Group>> searchGroupByFilters(List<String> filters) {
    Future<List<Group>> groups=
    groupsRef.where("category", whereIn: filters).limit(4).getDocuments().then((groupsQuerySnap){
      List<Group> groups = [];

      for(DocumentSnapshot group in groupsQuerySnap.documents){
        Group currGroup = Group.fromDoc(group);
        groups.add(currGroup);
      }

      return groups;
    });

    return groups;
  }

  static Future<List<Group>> searchGroupByName(String input) {
    Future<List<Group>> groups=
    groupsRef.where("title", isGreaterThanOrEqualTo: input).limit(4).getDocuments().then((groupsQuerySnap){
      List<Group> groups = [];

      for(DocumentSnapshot group in groupsQuerySnap.documents){
        Group currGroup = Group.fromDoc(group);
        groups.add(currGroup);
      }

      return groups;
    }


    );

    return groups;
  }

  static Future<List<Group>> searchGroupByNameAndFilters(String input, List<String> filters ) {
    Future<List<Group>> groups=
    groupsRef.where("title", isGreaterThanOrEqualTo: input).limit(4).getDocuments().then(
            (groupsQuerySnap) {
              List<Group> groups = [];
              List<Group> groupsFiltered = [];


              for(DocumentSnapshot group in groupsQuerySnap.documents){
                Group currGroup = Group.fromDoc(group);
                groups.add(currGroup);
              }

              groups.forEach((element) {
                if (filters.contains(element.category)){
                groupsFiltered.add(element);}
              });
              return groupsFiltered;
            }
    );

    return groups;
  }




//  static Future<QuerySnapshot> displayConnectionRequests(String currentUserId){
//    Future<QuerySnapshot> userIdsOfRequstedConnections =
//        .document(currentUserId)
//        .collection("userConnections")
//        .getDocuments();
//
//    return userIdsOfConnections;
//
// }

}
