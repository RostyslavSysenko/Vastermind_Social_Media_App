import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/task_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/screens/profileAndHome/profile_screen.dart';
import 'package:vastermind/utilities/constants.dart';

class RepeatingFunctions {
  static buildUserTile({User user, BuildContext context, String currentUserId}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: greyLight,
        backgroundImage: user.profileImageUrl.isEmpty ? AssetImage('assets/images/profileImage.png') :  CachedNetworkImageProvider(user.profileImageUrl),),
      title: Text("@" + user.name, style: TextStyle(color: lightBlue),),
      subtitle: Text(user.fullName, style: TextStyle(color: grey, fontSize: smallSizeText),),
      onTap: currentUserId == user.id ? ()=> null : () => Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(userId: user.id, currentuserId: Provider.of<UserData>(context).currentUserId,))),
    );
  }

  static getCurrWeekDateEnd(){
    DateTime dateTime = DateTime.now().add(Duration(days: 7 - DateTime.now().weekday)).add(Duration(days: 1));
    dateTime = getDateFromDateTime(dateTime);
    return dateTime;
  }
  static getCurrWeekDateStart(){
    DateTime dateTime = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    dateTime = getDateFromDateTime(dateTime);
    return dateTime;
  }
  static getDateFromDateTime(DateTime dateTime){
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, 0,0,0,0,0);
    return dateTime;
  }

  static String getRelativeDateConversion(actionDate) {
    DateTime RelationshipActionDate = RepeatingFunctions.getDateFromDateTime(actionDate.toDate());
    DateTime today =  RepeatingFunctions.getDateFromDateTime(DateTime.now());
    DateTime tomorrow = today.add(Duration(days: 1));


    if (RelationshipActionDate.isBefore(today)){
      return "Past";
    } else if (RelationshipActionDate.isAtSameMomentAs(today)){
      return "Today";
    } else if (RelationshipActionDate.isAtSameMomentAs(tomorrow)){
      return "Tomorrow";
    } else if (RelationshipActionDate.isAfter(tomorrow)){
      return "Future non-tomorrow";
    }
  }

  static getRelationshipDateTextColor(actionDate){
    String relativeDate = RepeatingFunctions.getRelativeDateConversion(actionDate);

    if (relativeDate == "Past"){
      return Colors.red;
    } else if (relativeDate == "Today"){
      return Colors.green;
    } else if (relativeDate == "Tomorrow" || relativeDate == "Future non-tomorrow"){
      return grey;
    }
  }

  static getSuccessScore(List<Task> logs, String display){
    var sucessScoreTotal = 0.0;
    var sucessScoreDivided;

    if (logs.length>0){
      logs.forEach((log) {
        sucessScoreTotal = sucessScoreTotal + log.totalScore;
      });
      sucessScoreDivided = sucessScoreTotal/logs.length;
      if(display == "accountability"){
        return "| " + sucessScoreDivided.toInt().toString() + "% success";
      } else {
        return sucessScoreDivided.toInt();
      }
    } else {
      return 0;
    }
  }



}
//template
//() => Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.id, (Route<dynamic> route) => false);

//draft
//Navigator.of(context).pushNamedAndRemoveUntil(MaterialPageRoute(builder: (_)=> ProfileScreen(userId: user.id, currentuserId: Provider.of<UserData>(context).currentUserId,)), (Route<dynamic> route) => false)


//initial
//() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> ProfileScreen(userId: user.id, currentuserId: Provider.of<UserData>(context).currentUserId,)))