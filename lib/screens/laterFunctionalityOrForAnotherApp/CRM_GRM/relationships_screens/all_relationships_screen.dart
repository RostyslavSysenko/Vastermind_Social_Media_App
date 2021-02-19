//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:vastermind/models/relationships/CRM_model.dart';
// import 'package:vastermind/models/relationships/GRM_model.dart';
// import 'package:vastermind/utilities/constants.dart';
// import 'package:vastermind/utilities/functions.dart';
// import 'package:vastermind/utilities/widgets.dart';
//
// class AllRelationshipsBodyContainer extends StatefulWidget {
//
//   List<CRM> relationshipsCRM;
//   List<GRM> relationshipsGRM;
//
//
//   AllRelationshipsBodyContainer({this.relationshipsCRM,this.relationshipsGRM});
//
//   @override
//   _AllRelationshipsBodyContainerState createState() => _AllRelationshipsBodyContainerState();
// }
//
// class _AllRelationshipsBodyContainerState extends State<AllRelationshipsBodyContainer> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Column(
//         children: [
//           Expanded(child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("CRM", style: TextStyle(color: lightBlue, fontSize: midSizeText)),
//               Row(
//                 children: [
//                   Text(widget.relationshipsCRM.length.toString() + " relationship/s | ", style: TextStyle(color: grey, fontSize: smallSizeText),),
//                   //number of Dates b
//                   Text(widget.relationshipsCRM.where((element) => (element.action == "Meet" && element.actionDate.toDate().isAfter(DateTime.now().subtract(Duration(days: 1))) && element.actionDate.toDate().isBefore(RepeatingFunctions.getCurrWeekDateEnd()))).length.toString() + " meeting/s left this week", style: TextStyle(color: grey, fontSize: smallSizeText),),
//                 ],
//               ),
//               Divider()
//             ],
//           )),
//           Expanded(
//             flex: 5,
//             child: widget.relationshipsCRM != null ? ListView.builder(
//               itemCount: widget.relationshipsCRM.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Text("sds $index");
//               },
//             ) : SizedBox()
//           ),
//           Expanded(child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Game", style: TextStyle(color: lightBlue, fontSize: midSizeText)),
//               Row(
//                 children: [
//                   Text(widget.relationshipsGRM.length.toString() + " relationship/s | ", style: TextStyle(color: grey, fontSize: smallSizeText),),
//                   //number of Dates b
//                   Text(widget.relationshipsGRM.where((element) => (element.action == "Meet" && element.actionDate.toDate().isAfter(DateTime.now().subtract(Duration(days: 1))) && element.actionDate.toDate().isBefore(RepeatingFunctions.getCurrWeekDateEnd()))).length.toString() + " date/s left this week", style: TextStyle(color: grey, fontSize: smallSizeText),),
//                 ],
//               ),
//               Divider()
//             ],
//           )),
//           Expanded(
//             flex: 5,
//             child: widget.relationshipsGRM != null ? ListView.builder(
//               itemCount: widget.relationshipsGRM.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTileGRM(name: widget.relationshipsGRM[index].name, action: widget.relationshipsGRM[index].action, actionDate: widget.relationshipsGRM[index].actionDate,);
//               },
//             ) : SizedBox(),
//           ),
//         ],
//       ),
//     );
//   }
//
//
// }
//
// class ListTileGRM extends StatelessWidget {
//   ListTileGRM({this.name, this.action, this.actionDate});
//
//   @required String name;
//   @required String action;
//   @required Timestamp actionDate;
//
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: 0),
//       title: Text(name, style: TextStyle(color: lightBlue),),
//       subtitle: Text(DateFormat('EEE, MMM d ').format(actionDate.toDate()).toString(),style: TextStyle(
//           color:RepeatingFunctions.getRelationshipDateTextColor(actionDate)
//
//
//       ),),
//       trailing: action == "Meet" ? Icon(Icons.supervisor_account_rounded, size: 20, color: lightBlue,) :
//       action == "Call" ? Icon(Icons.phone, size: 20, color: lightBlue,) :
//       action == "Message" ? Icon(Icons.send_rounded, size: 20, color: lightBlue,) :
//       action == "Ping" ? Icon(Icons.auto_awesome, size: 20, color: lightBlue,) : SizedBox(),
//     );
//   }
//
//   static sortList(List list, property){
//     list.sort((a, b){
//       return a.property.compareTo(b.property);
//     });
//     list = List.from(list.reversed);
//
//     return list;
//   }
//
//
//
//
// }
//
