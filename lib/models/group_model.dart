import 'package:cloud_firestore/cloud_firestore.dart';

class Group{
  String id;
  String groupName;
  String groupDescription;
  String leader;
  List members;
  Timestamp groupCreated;
  String category;
  String actionOneName;
  String actionTwoName;
  String actionThreeName;
  int sucessTarget;
  Timestamp groupEndDate;
  int logGroupFrequencyInDays;

  int choiceIndex;
  int progressLogFrequencyInDays;
  int progressLogDuration;
  int sessionFrequencyInDays;
  int sessionDuration;





  Group({this.id, this.logGroupFrequencyInDays, this.groupEndDate, this.groupCreated, this.leader, this.members, this.sucessTarget,this.actionThreeName,this.actionTwoName,this.actionOneName,this.groupName,this.category,this.groupDescription, this.sessionDuration,this.sessionFrequencyInDays,this.progressLogDuration,this.progressLogFrequencyInDays,this.choiceIndex});


  factory Group.fromDoc(DocumentSnapshot doc){
    return Group(
      id: doc.documentID,
      groupName: doc["title"] ,
      groupDescription : doc["description"] ,
      category : doc["category"] ,
      actionOneName : doc["actionOneName"]  ,
      actionTwoName : doc["actionTwoName"]  ,
      actionThreeName : doc["actionThreeName"]  ,
      sucessTarget : doc["successTarget"]  ,
      groupEndDate : doc["GroupEndDate"]  ,
      logGroupFrequencyInDays : doc["groupLogFrequencyInDays"] ,
      leader : doc["leader"],
      members : doc["members"],
      groupCreated : doc["groupCreate"],

      choiceIndex: doc["rowChoiceIndex"],
        progressLogFrequencyInDays : doc["rowProgressLogFrequencyInDays"],
        progressLogDuration : doc["rowProgressLogDuration"],
        sessionFrequencyInDays : doc["rowSessionFrequencyInDays"],

        sessionDuration : doc["rowSessionDuration"],


    );
  }




}