library constants;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

const Color black = Color(0xFF040403);
const Color darkBlue = Color(0xFF054A91);
const Color lightBlue = Color(0xFF5DA9E9);
const Color white = Color(0xFFFFFFFF);
Color grey = Colors.grey[500];
Color greyLight = Colors.grey[200];

final double smallSizeText = 12;
final double midSizeText = 18;
final double largeSizeText = 30;
final double vLargeSizeText = 50;

final firestore = Firestore.instance;
final usersRef = firestore.collection("users");
final storageRef = FirebaseStorage.instance.ref();
final postsRef = firestore.collection("posts");
final followersRef = firestore.collection("followers");
final followingRef = firestore.collection("following");
final connectionsRef = firestore.collection("connections");
final messagesRef = firestore.collection("messages");
final connectionRequestsRef = firestore.collection("connectionRequests");
final groupsRef = firestore.collection("groups");

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: lightBlue, width: 2.0),
  ),
);