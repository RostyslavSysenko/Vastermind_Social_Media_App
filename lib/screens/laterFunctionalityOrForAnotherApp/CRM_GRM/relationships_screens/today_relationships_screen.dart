//
//
// import 'package:flutter/material.dart';
// import 'package:vastermind/models/relationships/CRM_model.dart';
// import 'package:vastermind/models/relationships/GRM_model.dart';
// import 'package:vastermind/utilities/constants.dart';
// import 'package:vastermind/utilities/functions.dart';
//
// import 'all_relationships_screen.dart';
//
// class TodayRelationshipsBodyContainer extends StatefulWidget {
//
//   List<CRM> relationshipsCRM;
//   List<GRM> relationshipsGRM;
//
//   TodayRelationshipsBodyContainer({this.relationshipsCRM,this.relationshipsGRM});
//
//   @override
//   _TodayRelationshipsBodyContainerState createState() => _TodayRelationshipsBodyContainerState();
// }
//
// class _TodayRelationshipsBodyContainerState extends State<TodayRelationshipsBodyContainer> {
//
//   List<CRM> relationshipsCRMFiltered = [];
//   List<GRM> relationshipsGRMFiltered = [];
//
//   @override
//   void initState() {
//     super.initState();
//     getTodayViewRelationshipGRMList();
//   }
//
//   getTodayViewRelationshipGRMList(){
//       for(int i = 0; i < this.widget.relationshipsGRM.length; i++){
//         GRM currItem = widget.relationshipsGRM[i];
//         String relativeDate = RepeatingFunctions.getRelativeDateConversion(currItem.actionDate);
//         if ( relativeDate == "Today" || relativeDate == "Past"){
//           relationshipsGRMFiltered.add(currItem);
//         }
//       }
//
//   }
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
//                   Text(relationshipsCRMFiltered.length.toString() + " actions left today ", style: TextStyle(color: grey, fontSize: smallSizeText),),
//                 ],
//               ),
//               Divider()
//             ],
//           )),
//           Expanded(
//               flex: 5,
//               child: widget.relationshipsCRM != null ? ListView.builder(
//                 itemCount: widget.relationshipsCRM.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Text("sds $index");
//                 },
//               ) : SizedBox()
//           ),
//           Expanded(child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Game", style: TextStyle(color: lightBlue, fontSize: midSizeText)),
//               Row(
//                 children: [
//                   Text(relationshipsGRMFiltered.length.toString() + " actions left today ", style: TextStyle(color: grey, fontSize: smallSizeText),),
//                 ],
//               ),
//               Divider()
//             ],
//           )),
//
//
//
//           Expanded(
//             flex: 5,
//             child: relationshipsGRMFiltered != null ? ListView.builder(
//               itemCount: relationshipsGRMFiltered.length,
//               itemBuilder: (BuildContext context, int index) {
//                   return ListTileGRM(name: relationshipsGRMFiltered[index].name, action: relationshipsGRMFiltered[index].action, actionDate: relationshipsGRMFiltered[index].actionDate,);
//                 return SizedBox();
//               },
//             ) : SizedBox(),
//           ),
//         ],
//       ),
//     );
//   }
// }
