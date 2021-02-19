import 'package:cloud_firestore/cloud_firestore.dart';



class User{

  @override
  String toString() {
    return name;
  }

  final String id;
  final String fullName;
  final String name;
  final String profileImageUrl;
  final String email;
  int numOfFollowers;
  int numFollowing;
  int numOfConnections;
  String groupId;

  User({this.id,this.name,this.email,this.profileImageUrl, this.fullName, this.numFollowing,this.numOfConnections, this.numOfFollowers, this.groupId});

  factory User.fromDoc(DocumentSnapshot doc){
    return User(
      id: doc.documentID,
      name: doc["name"], //user tag
      profileImageUrl: doc["profileImageUrl"],
      email: doc["email"],
      fullName: doc["fullName"],
      numOfFollowers: doc["numOfFollowers"],
      numFollowing: doc["numFollowing"],
        numOfConnections : doc["numOfConnections"],
      groupId : doc["groupId"],

    );
  }

}