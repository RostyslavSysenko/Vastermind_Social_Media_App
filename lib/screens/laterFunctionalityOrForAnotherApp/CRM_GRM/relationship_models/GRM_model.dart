import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GRM {
  //primary
  @required String name;

  String action;
  Timestamp actionDate;

  //relationship
  String relationshipType;
  String stage;
  String compliance;
  int numOfWarnings;

  //about her
  int rating;
  String methodOfContact;
  String phenotype;

  //execution and learning
  String lessonSummary;
  String howToProceed;
  bool lessonConfirmed;

  GRM({
    this.actionDate,
    this.action,
    this.name,
    this.compliance,
    this.howToProceed,
    this.lessonConfirmed,
    this.lessonSummary,
    this.methodOfContact,
    this.numOfWarnings,
    this.phenotype,
    this.rating,
    this.relationshipType,
    this.stage
});

  factory GRM.fromDoc(DocumentSnapshot doc){
   return GRM(
       actionDate: doc["actionDate"],
       action: doc["action"],
       name: doc["name"],
       compliance: doc["compliance"],
       howToProceed: doc["howToProceed"],
       lessonConfirmed: doc["lessonConfirmed"],
       lessonSummary: doc["lessonSummary"],
       methodOfContact: doc["methodOfContact"],
       numOfWarnings: doc["numOfWarnings"],
       phenotype: doc["phenotype"],
       rating: doc["rating"],
       relationshipType: doc["relationshipType"],
       stage: doc["stage"]
   );
  }
}