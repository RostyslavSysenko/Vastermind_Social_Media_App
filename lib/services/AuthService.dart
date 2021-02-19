import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';

class AuthService{
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static signUpUser(BuildContext context, String name, String email, String password, String fullName) async{
    try{
      String userNameStatus = "";
      await usersRef.getDocuments().then((users){
        final usersIter = users.documents.iterator;
        while(usersIter.moveNext()){
          if(usersIter.current.data["name"] == name){
            print("repeated name");
            userNameStatus ="Username already in use";
          }
        }


      });

      if(userNameStatus.isEmpty){
        AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        FirebaseUser signedInUser = authResult.user;
        if (signedInUser != null){
          _firestore.collection("/users").document(signedInUser.uid).setData({
            "name": name.toLowerCase() ,
            "email" : email,
            "fullName" : fullName,
            "profileImageUrl" : "",
            "numOfFollowers" : 0,
            "numFollowing" : 0,
            "numOfConnections" : 0,
            "groupId" : "YD50C1fCVbHsB2aGyZ03",
          });
          
          await DatabaseService.addMember("YD50C1fCVbHsB2aGyZ03", signedInUser.uid);
          print("the name is" + name);
          //after user signed u[ we dont want them to be able to go back to the sign up scree and thus we have the pushReplacementNamed
          //the reason pop works here is because the home screen is being opened on login screen and we
          //are on sign up screen so we needed to pop out from sign up screen to see it.
        }
        return "Successfully registered";
      } else {
        return userNameStatus;
      }

    } catch (e) {
      if(e.toString() == "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)"){
        return "Email already in use";
      } else return e.toString();
    }
  }

  static void logout(BuildContext context) {
    _auth.signOut();

  }

  static void login (String email, String password, BuildContext context) async {
   await  _auth.signInWithEmailAndPassword(email: email, password: password);
  }


}