




// int currRelationshipView = 0;
// List<CRM> relationshipListCRM = [];
// List<GRM> relationshipListGRM = [];
//


// app bar actions
// actions: _selectedIndex == 1 ? [
//           Ink(
//             child: IconButton(
//               color: currRelationshipView == 0? lightBlue : grey,
//               icon: Icon(
//                 Icons.today_rounded,
//                 size: largeSizeText+1,
//               ),
//               //color: grey,
//               onPressed: (){
//                 setState(() {
//                   currRelationshipView =0;
//                 });
//               }
//             ),
//           ) ,
//            Ink(
//             child: IconButton(
//               icon: Icon(
//                 Icons.archive_rounded,
//                 size: largeSizeText,
//               ),
//               color: currRelationshipView == 1? lightBlue : grey,
//               onPressed: (){
//                 setState(() {
//                   currRelationshipView =1;
//                 });
//               }
//             ),
//           )
//         ] : [],
//appbar settings
//title: relationshipAppBar(),

// relationshipsContainerBody() {
//   return Scaffold(
//     floatingActionButton: FloatingActionButton(
//       onPressed: (){
//         showModalBottomSheet(
//             shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.vertical(top: Radius.circular(10.0))),
//             isScrollControlled: true,
//             context: context,
//             builder: (context) =>
//
//                 AddRelationshipScreen(
//                         (name, action, relationshipType, actionDate) async {
//
//
//                       //creating relationship object
//                       if(relationshipType == "Game"){
//                         GRM grm = GRM(name: name, action: action, actionDate: Timestamp.fromDate(actionDate));
//                         setState(() {
//                           relationshipListGRM.add(grm);
//                         });
//                       } else if(relationshipType == "CRM"){
//                         CRM crm = CRM(name: name, action: action, actionDate: Timestamp.fromDate(actionDate));
//                         setState(() {
//                           relationshipListCRM.add(crm);
//                         });
//
//                       }
//
//
//                       Navigator.pop(context);
//
//                     }
//                 )
//
//
//         );
//       },
//       backgroundColor: lightBlue,
//       child: Icon(
//         Icons.add,
//         color: white,
//       ),
//     ),
//     body: Container(
//       child: currRelationshipView == 0 ? TodayRelationshipsBodyContainer(relationshipsCRM: relationshipListCRM, relationshipsGRM: relationshipListGRM,):
//       AllRelationshipsBodyContainer(relationshipsCRM: relationshipListCRM, relationshipsGRM: relationshipListGRM),
//
//     ),
//   );
// }
//
// relationshipAppBar() {
//   if(currRelationshipView == 0){
//     return Text(
//       "Today",
//       style: TextStyle(color: lightBlue),
//     );
//   } else if (currRelationshipView == 1){
//     return Text(
//       "All",
//       style: TextStyle(color: lightBlue),
//     );
//   }
// }
// }