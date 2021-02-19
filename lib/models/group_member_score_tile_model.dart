import 'package:flutter/material.dart';

class GroupMemberScoreTileModel{
  @required int sucessScore;
  @required int logNum;
  @required String fullName;
  @required String profileImageUrl;

  GroupMemberScoreTileModel({this.profileImageUrl,this.fullName,this.logNum, this.sucessScore});
}