import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CRM {
  //primary
  @required final String name;

  final String action;
  final Timestamp actionDate;

  final String notes;

  //recurring contact

  int contactFrequencyNumber;
  String contactFrequencyUnit;
  Timestamp lastDateContacted;
  String prefferedContact;

  //additional info

  final String relationshipStatus;
  final String relationshipStatusGoal;

  final String valueIWantFromLead;
  final String valueICanOffer;

  final String relationshipPotential;
  final String planForAchievingRelationshipPotential;


  CRM({this.name, this.notes, this.action, this.actionDate, this.contactFrequencyNumber, this.contactFrequencyUnit, this.lastDateContacted,this.planForAchievingRelationshipPotential,this.prefferedContact, this.relationshipPotential,this.relationshipStatus,this.relationshipStatusGoal,this.valueICanOffer,this.valueIWantFromLead});


  factory CRM.fromDoc(DocumentSnapshot doc){
    return CRM(
        name: doc["name"],
      action: doc["action"],
      actionDate: doc["actionDate"],
      contactFrequencyNumber: doc["contactFrequencyNumber"],
      contactFrequencyUnit: doc["contactFrequencyUnit"],
      relationshipStatusGoal: doc["relationshipStatusGoal"],
      valueIWantFromLead: doc["valueIWantFromLead"],
      planForAchievingRelationshipPotential: doc["planForAchievingRelationshipPotential"],
      lastDateContacted: doc["lastDateContacted"],
      prefferedContact: doc["prefferedContact"],
      notes: doc["notes"],
      relationshipPotential: doc["relationshipPotential"],
      relationshipStatus: doc["relationshipStatus"],
      valueICanOffer: doc["valueICanOffer"],
    );
  }
}