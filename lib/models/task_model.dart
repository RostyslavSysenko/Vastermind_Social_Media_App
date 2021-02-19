import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {


  @required final DateTime date;
  final String note;
  final double progressScoreOne;
  final double progressScoreTwo;
  final double progressScoreThree;
  final double totalScore;

  Task({this.date = null, this.progressScoreOne = 0, this.progressScoreThree = 0, this.progressScoreTwo = 0, this.note = "", this.totalScore = 0});


  factory Task.fromDoc(DocumentSnapshot doc){
    var num = doc["progressScoreThree"];
    num  = num+0.0;

    return Task(
      date: doc["date"].toDate(),
      note: doc["note"],
      progressScoreOne: doc["progressScoreOne"],
      progressScoreTwo: doc["progressScoreTwo"],
      progressScoreThree: num,
      totalScore: doc["totalScore"]
    );
  }
}
