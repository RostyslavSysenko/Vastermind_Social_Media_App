import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/task_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/screens/profileAndHome/profile_screen.dart';
import 'package:vastermind/services/databaseService.dart';

import 'constants.dart';

class SecondaryAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  String title;

  SecondaryAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: white,
      title: Text(
        title,
        style: TextStyle(color: lightBlue),
      ),
    );
  }
}


class GroupAddTile extends StatefulWidget {
  @required User user;
  @required BuildContext context;
  @required String currentUserId;
  @required List groupMembers;
  @required String leaderUserId;
  @required bool editable;

  GroupAddTile({this.currentUserId, this.context, this.user, this.groupMembers, this.leaderUserId, this.editable});


  @override
  _GroupAddTileState createState() => _GroupAddTileState();
}

class _GroupAddTileState extends State<GroupAddTile> {
  bool added;
  List groupMembers;


  @override
  void initState() {
    super.initState();
    widget.groupMembers.contains(widget.user.id) ? added = true : added = false;
    groupMembers = List<String>.from(widget.groupMembers);
  }

  isLeader(){
    if(widget.leaderUserId == widget.user.id){
      return " leader";
    }
    else return "member";
  }


  @override
  Widget build(BuildContext context) {
    return widget.editable ? ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: greyLight,
        backgroundImage: widget.user.profileImageUrl.isEmpty ? AssetImage('assets/images/profileImage.png') :  CachedNetworkImageProvider(widget.user.profileImageUrl),),
      title: Row(children: [
        Text("@" + widget.user.name, style: TextStyle(color: grey, fontSize: midSizeText),),
      ],),
      subtitle: Text(widget.user.fullName, style: TextStyle(color: grey, fontSize: smallSizeText),),
      trailing: added == false ? Icon(Icons.add_circle_rounded, color: Colors.green,) : Icon(Icons.remove_circle_outline_rounded, color: Colors.red,),
      onTap: (){
        setState(() {
          if(added == true){
            groupMembers.remove(widget.user.id);
            DatabaseService.removeMember(Provider.of<UserData>(context, listen: false).userGroupId, widget.user.id);
          } else {
            groupMembers.add(widget.user.id);
            DatabaseService.addMember(Provider.of<UserData>(context, listen: false).userGroupId, widget.user.id);
          }
          added = !added;
        });

      },
    )

        :


    ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: greyLight,
        backgroundImage: widget.user.profileImageUrl.isEmpty ? AssetImage('assets/images/profileImage.png') :  CachedNetworkImageProvider(widget.user.profileImageUrl),),
      title: Text(widget.user.name, style: TextStyle(color: grey, fontSize: smallSizeText),),
      subtitle: Text(widget.user.fullName, style: TextStyle(color: grey, fontSize: smallSizeText),),
      trailing: Text(isLeader(), style: TextStyle(color: lightBlue, fontSize: smallSizeText),),
      onTap:(){return Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfileScreen(userId: widget.user.id, currentuserId: Provider.of<UserData>(context).currentUserId,)));}
    );
  }
}

Widget appBarDefault = AppBar(
  backgroundColor: white,
  centerTitle: true,
  title: Text(
    "Vastermind",
    style: TextStyle(
        color: lightBlue, fontFamily: "TechnaSans", fontSize: largeSizeText),
  ),
);

class CurrUserOnlyProfileScreenButton extends StatelessWidget {
  CurrUserOnlyProfileScreenButton(
      {this.user,
      this.iconData,
      this.subtitle,
      this.title,
      this.function,
      this.currUser});

  @required
  final Function function;
  @required
  final String title;
  @required
  final String subtitle;
  @required
  final IconData iconData;
  @required
  final User user;
  @required
  final String currUser;
  @required
  final double horizontalInBoxPadding = 10;
  @required
  final double verticalInBoxPadding = 16;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: function,
        child: user.id == currUser
            ? Card(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      horizontalInBoxPadding,
                      verticalInBoxPadding,
                      horizontalInBoxPadding,
                      verticalInBoxPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        iconData,
                        size: 40,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: midSizeText,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            subtitle,
                            style:
                                TextStyle(fontSize: smallSizeText, color: grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : SizedBox());
  }
}

class PrivacyProfileButton extends StatelessWidget {
  const PrivacyProfileButton(
      {Key key,
      @required this.privacyAccessGranted,
      @required this.title,
      @required this.icon,
      @required this.subtitle,
      @required this.functionality})
      : super(key: key);

  final bool privacyAccessGranted;
  final String title;
  final String subtitle;
  final Function functionality;
  final IconData icon;
  final double horizontalInBoxPadding = 10;
  final double verticalInBoxPadding = 16;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: functionality,
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              horizontalInBoxPadding,
              verticalInBoxPadding,
              horizontalInBoxPadding,
              verticalInBoxPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              privacyAccessGranted
                  ? Icon(icon, size: 40, color: lightBlue)
                  : Icon(Icons.lock_rounded, size: 40, color: grey),
              SizedBox(
                width: 14,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: midSizeText, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: smallSizeText, color: grey),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilledSecondaryButton extends StatelessWidget {
  @required
  String title;
  @required
  Color color;
  @required
  Function function;
  @required
  double top;
  @required
  String buttonSize;

  FilledSecondaryButton(
      {this.title, this.color, this.function, this.top, this.buttonSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, top, 0, 10),
      height: 40,
      width: buttonSize == "small"
          ? 100
          : buttonSize == "mid"
              ? 190
              : MediaQuery.of(context).size.width -40,
      child: FlatButton(
        onPressed: function,
        color: color,
        textColor: white,
        child: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class ButtonNoFill extends StatelessWidget {
  ButtonNoFill({this.title, this.function, this.textSize,this.textColor = lightBlue, this.padding});

  @required
  Function function;
  @required
  String title;
  @required
  double textSize;
  Color textColor;
  EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: padding,
      onPressed: function,
      child: Text(title,
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: textSize,
          )),
    );
  }
}

class ListTileCust extends StatelessWidget {
  const ListTileCust(
      {  @required this.date,
        @required    this.progressScoreOne,
        @required      this.progressScoreTwo,
        @required    this.progressScoreThree,  @required this.note,  @required this.totalScore,  @required this.targetScore});

 final DateTime date;
final double progressScoreOne;
 final double progressScoreTwo;
 final double progressScoreThree;
final String note;
 final double totalScore;
 final int targetScore;


  totalScoreEmojy(double progressScoreOne, double progressScoreTwo,
      double progressScoreThree) {
    Icon icon;

    totalScore < targetScore/2
        ? icon = Icon(Icons.emoji_events_rounded, size: 20, color: Colors.red,)
        : totalScore < targetScore
            ? icon =  Icon(Icons.emoji_events_rounded, size: 20, color: Colors.orange,)
            : icon =  Icon(Icons.emoji_events_rounded, size: 20, color: Colors.green,);


    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: !note.isEmpty ? (){showDialog(
        context: context,
        child: Container(
          width: 200,
          height: 200,
          child: SimpleDialog(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.all(10),
            titlePadding: EdgeInsets.only(top: 10, left: 10, right: 10),
            title: Text(DateFormat('EEE, MMM d ').format(date).toString(),style: TextStyle(color: lightBlue),),
            children: [
              Divider(),
              Container(child: SingleChildScrollView(child: Text(note, style: TextStyle(color: grey, fontSize: midSizeText),)), height: MediaQuery.of(context).size.height/2,width: MediaQuery.of(context).size.width/1.5)

            ],
          ),
        ),
      );} : (){},
      title: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              DateFormat('EEE, MMM d ').format(date).toString(),
              style: TextStyle(color: lightBlue, fontSize: smallSizeText),
            ),
          ),
          Expanded(
            flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
            Text(progressScoreOne.toInt().toString(), style: TextStyle(color: lightBlue, fontSize: smallSizeText),),
            Text(progressScoreTwo.toInt().toString(), style: TextStyle(color: lightBlue, fontSize: smallSizeText),),
            Text(progressScoreThree.toInt().toString(), style: TextStyle(color: lightBlue, fontSize: smallSizeText),),
            !note.isEmpty ? Icon(Icons.sticky_note_2_rounded, color: lightBlue, size: 20,) : Icon(Icons.sticky_note_2_rounded, color: greyLight, size: 20,)
          ],))


        ],
      ),
      trailing: totalScoreEmojy(
          progressScoreOne, progressScoreTwo, progressScoreThree),
    );
  }
}

class SeparationWidget extends StatelessWidget {
  SeparationWidget({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Text(
                title,
                style: TextStyle(color: grey),
              )
            : SizedBox(),
        Divider(
          color: grey,
          thickness: 0.5,
        )
      ],
    );
  }
}

class ListViewCust extends StatefulWidget {

  @required List<Task> tasks = [];
   int targetSuccessScore;

  ListViewCust({this.tasks,@required this.targetSuccessScore });



  @override
  _ListViewCustState createState() => _ListViewCustState();
}

class _ListViewCustState extends State<ListViewCust> {



  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: widget.tasks.length,
        itemBuilder: (BuildContext context, index){
          final task = "${widget.tasks[index].date}";
          return Dismissible(
            key: Key(task),
            background: Container(
              padding: EdgeInsets.only(right: 20.0),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Text(
                'Delete',
                textAlign: TextAlign.right,
                style: TextStyle(color: white),
              ),
            ),
            onDismissed: (direction){
              setState(() {
                DatabaseService.deleteLog(widget.tasks[index].date, Provider.of<UserData>(context, listen: false).currentUserId, Provider.of<UserData>(context, listen: false).userGroupId);
                widget.tasks.removeAt(index);

              });
            },
            child: ListTileCust(
              date: widget.tasks[index].date,
              progressScoreOne: widget.tasks[index].progressScoreOne,
              progressScoreTwo: widget.tasks[index].progressScoreTwo,
              progressScoreThree: widget.tasks[index].progressScoreThree,
              note: widget.tasks[index].note,
              totalScore: widget.tasks[index].totalScore,
                targetScore: widget.targetSuccessScore,
            ),
          );

        },
    );
  }
}


//
// class BuildChip extends StatelessWidget {
//
//   bool selectionStatus;
//   Function function;
//   String title;
//
//   BuildChip(this.selectionStatus, this.function , this.title );
//
//   @override
//   Widget build(BuildContext context) {
//     return InputChip(
//       // shape: RoundedRectangleBorder(
//       //     side: BorderSide(
//       //         color: selectionStatus ? lightBlue : grey,
//       //         width: 1,
//       //         style: BorderStyle.solid),
//       //     borderRadius: BorderRadius.circular(50)),
//       // padding: EdgeInsets.all(2.0),
//       // avatar: CircleAvatar(
//       //   backgroundColor: selectionStatus ? lightBlue : white,
//       //   foregroundColor: selectionStatus ? white : grey,
//       //   child: Icon(Icons.directions_run_rounded),
//       // ),
//       // label: Text(
//       //   title,
//       //   style: TextStyle(
//       //       color:
//       //       selectionStatus ? white : grey),
//       // ),
//       // selected: selectionStatus,
//       // selectedColor: lightBlue,
//       // backgroundColor: white,
//       //deleteIconColor: selectionStatus ? white : grey,
//       onSelected: (bool selected){
//         function(selected);
//       },
//       //onDeleted: () {},
//     );
//   }
// }

