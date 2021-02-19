import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vastermind/models/group_model.dart';
import 'package:vastermind/utilities/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/widgets.dart';

class AccountabilityGroupSettingsScreen extends StatefulWidget {
  static final String id = "accountability_group_settings_screen";

  @override
  _AccountabilityGroupSettingsScreenState createState() =>
      _AccountabilityGroupSettingsScreenState();
}

class _AccountabilityGroupSettingsScreenState
    extends State<AccountabilityGroupSettingsScreen> {
  _addUsers() {
    Future<QuerySnapshot> _usersConnections;
    Future<DocumentSnapshot> _groupMembers;

    _usersConnections = DatabaseService.displayConnections(
        Provider.of<UserData>(context, listen: false).currentUserId);

    _groupMembers = DatabaseService.getGroupMembers(
        Provider.of<UserData>(context, listen: false).userGroupId);

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        //isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: _usersConnections == null
                ? Text("Please connect to the internet")
                : FutureBuilder(
                    future: Future.wait([_usersConnections, _groupMembers]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        print("doesnt have data");
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data[0].documents.length == 0) {
                        print("length 0");
                        return Center(child: Text("Currently no connections"));
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                            //detects the presence of keyboard
                            bottom: 10,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "You can only add your connections",
                                style: TextStyle(
                                    color: grey, fontSize: smallSizeText),
                              ),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data[0].documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot membersSnapshot =
                                      snapshot.data[1];
                                  List members =
                                      membersSnapshot.data["members"];

                                  User user = User.fromDoc(
                                      snapshot.data[0].documents[index]);

                                  return GroupAddTile(
                                    editable: true,
                                    user: user,
                                    leaderUserId: group.leader,
                                    context: context,
                                    currentUserId:
                                        Provider.of<UserData>(context)
                                            .currentUserId,
                                    groupMembers: members,
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
          );
        });
  }



  final _formKey = GlobalKey<FormState>();

  // getDateTimeRange(DateTime startDate, DateTime endDate) {
  //   dateTimeRange = DateTimeRange(start: startDate, end: endDate);
  // }

   final _choiceTitles = ["Fitness",'Learning a habit','Learning a skill',"Happiness", "Personal Growth", 'Side Hustle', 'Relationships',
  'Study', "Other"];

  final _choiceIcons =[Icons.directions_run, Icons.alarm_on_rounded, Icons.architecture_rounded, Icons.tag_faces_rounded, Icons.show_chart_rounded, Icons.work_rounded, Icons.people_rounded, Icons.book_rounded, Icons.add
  ];

  //Step 1
  String oneSentanceStatement = "";
  String goalDescription = "";
  String categoryName = "";
  int _choiceIndex;


  String itemOneName = "";
  String itemTwoName = "";
  String itemThreeName = "";

  DateTime endDate;
  int logFrequencyInDays;

  int progressLogFreuqnecyInDays;
  int progressLogDuration;

  int sessionFreuqencyInDays;
  int sessionDuration;
  int sucessScore;


  String error = "";

  Widget _buildChoiceChips() {

    return Container(
      height: MediaQuery.of(context).size.height/12,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _choiceTitles.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      selectedColor: lightBlue,
                      backgroundColor: white,
                      label: Text(
                        _choiceTitles[index],
                        style: TextStyle(
                            color:
                            _choiceIndex == index ? white : grey),
                      ),
                      avatar: CircleAvatar(
                        backgroundColor: _choiceIndex == index ? lightBlue : white,
                        child: Icon(_choiceIcons[index], color: _choiceIndex == index ? white : grey,),
                      ),
                      padding: EdgeInsets.all(2.0),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: _choiceIndex == index ? lightBlue : grey,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)),
                      selected: _choiceIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _choiceIndex = selected ? index : index;
                          categoryName = _choiceTitles[_choiceIndex];
                        });
                      },
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  );

              },
            ),
          ),
        ],
      ),
    );
  }

  Group group;
  bool indexActivated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: "Group Settings"),
      body: FutureBuilder(
        future: DatabaseService.getAllGroupDetails(Provider.of<UserData>(context).userGroupId),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          else{
            group = Group.fromDoc(snapshot.data);

            if (indexActivated == false){
               _choiceIndex = group.choiceIndex;
               categoryName = group.category;


               progressLogFreuqnecyInDays = group.progressLogFrequencyInDays;
               sessionFreuqencyInDays = group.sessionFrequencyInDays;

               indexActivated = true;

              }


            return SingleChildScrollView(
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                        Column(
                        children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilledSecondaryButton(
                                top: 10,
                                title: "Edit Members",
                                color: lightBlue,
                                buttonSize: "large",
                                function: _addUsers),

                          ],
                        ),
                        Divider(),
                        if(error.isNotEmpty)Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(error, style: TextStyle(color: Colors.red, fontSize: smallSizeText),),
                    ],
                  )else SizedBox(),
              TextFormField(
                initialValue: group.groupName,
                style: TextStyle(color: grey, fontSize: midSizeText),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                maxLength: 25,
                decoration: InputDecoration(
                  labelText: "1 sentance Goal Statement",
                  labelStyle: TextStyle(color: grey, fontSize: smallSizeText),
                  icon: Icon(
                    Icons.short_text_rounded,
                    size: 30,
                  ),
                ),
                onSaved: (input) => oneSentanceStatement = input,
              ),
              TextFormField(
                initialValue: group.groupDescription,
                style: TextStyle(color: grey, fontSize: midSizeText),
                validator: (value) {
                  if (value.isEmpty || value.length < 30) {
                    return 'Please describe purpose of this group with more detail';
                  }
                  return null;
                },
                maxLength: 250,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: grey, fontSize: smallSizeText),
                  labelText: "Group Description",
                  icon: Icon(
                    Icons.notes,
                    size: 30,
                  ),
                ),
                onSaved: (input) => goalDescription = input,
              ),
              _buildChoiceChips(),
              Divider(),
              TextFormField(
                initialValue: group.actionOneName,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                maxLength: 15,
                style: TextStyle(color: grey, fontSize: midSizeText),
                decoration: InputDecoration(
                  labelText: "Action Item 1 Name",
                  labelStyle: TextStyle(color: grey, fontSize: smallSizeText),
                  icon: Icon(
                    Icons.accessibility_new_rounded,
                    size: 30,
                  ),
                ),
                onSaved: (input) => itemOneName = input,
              ),
              TextFormField(
                initialValue: group.actionTwoName,
                style: TextStyle(color: grey, fontSize: midSizeText),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: "Action Item 2 Name",
                  labelStyle: TextStyle(color: grey, fontSize: smallSizeText),
                  icon: Icon(
                    Icons.accessibility_new_rounded,
                    size: 30,
                  ),
                ),
                onSaved: (input) => itemTwoName = input,
              ),
              TextFormField(
                initialValue: group.actionThreeName,
                style: TextStyle(color: grey, fontSize: midSizeText),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: "Action Item 3 Name",
                  labelStyle: TextStyle(color: grey, fontSize: smallSizeText),
                  icon: Icon(
                    Icons.accessibility_new_rounded,
                    size: 30,
                  ),
                ),
                onSaved: (input) => itemThreeName = input,
              ),
              Divider(),





              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: group.sessionDuration.toString(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      style: TextStyle(color: grey, fontSize: midSizeText),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Session Duration",
                        labelStyle: TextStyle(color: grey, fontSize: smallSizeText),
                        icon: Icon(
                          Icons.calendar_today_rounded,
                          size: 30,
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      onSaved: (input) => sessionDuration = num.tryParse(input),
                    ),

                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/10),
                  Expanded(
                    child: DropDownMenuFrequencyUnitSelection(selectedOptionCallback: (input){
                      sessionFreuqencyInDays = input;
                    },
                      frequencyUnitScore: group.sessionFrequencyInDays,

                    ),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: group.logGroupFrequencyInDays.toString(),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  style: TextStyle(color: grey, fontSize: midSizeText),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                      labelText: "Progress Log Frequency",
                      labelStyle:
                       TextStyle(color: grey, fontSize: smallSizeText),
                                      icon: Icon(
                                        Icons.av_timer_rounded,
                                        size: 30,
                                      ),
                                    ),
                                    onSaved: (input) {
                                      progressLogDuration = num.tryParse(input);
                                    },
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/10),
                                Expanded(
                                  child: DropDownMenuFrequencyUnitSelection(selectedOptionCallback: (logFrequencyDays){
                                    progressLogFreuqnecyInDays = logFrequencyDays;
                                  }, frequencyUnitScore: group.progressLogFrequencyInDays,),
                                ),
                              ],
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              initialValue: group.sucessTarget.toString(),
                              style: TextStyle(color: grey, fontSize: midSizeText),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                labelText: "Desired Success Score (0-100)",
                                labelStyle: TextStyle(color: grey, fontSize: smallSizeText),
                                icon: Icon(
                                  Icons.emoji_events_rounded,
                                  size: 30,
                                ),
                              ),
                              onSaved: (input) => sucessScore = num.tryParse(input),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ButtonNoFill(
                                  textSize: smallSizeText,
                                  title: "Cancel",
                                  function: () {
                                    Navigator.of(context).pop();
                                  }
                              ),
                            ),
                            Expanded(
                              child: FilledSecondaryButton(
                                top: 0,
                                title: "Update",
                                color: lightBlue,
                                buttonSize: "mid",
                                function: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();

                                    if (categoryName.isEmpty){
                                      setState(() {
                                        error = "Choose category to proceed";
                                      });
                                      return;
                                    }
                                    print("error: " + error);
                                    if (progressLogFreuqnecyInDays == null || progressLogFreuqnecyInDays == 0){
                                      setState(() {
                                        error = "Select Log Frequency from drop down menu";
                                      });
                                      return;
                                    }

                                    if (sessionFreuqencyInDays == null || sessionFreuqencyInDays == 0){
                                      setState(() {
                                        error = "Select session frequency from drop down menu";
                                      });
                                      return;
                                    }
                                    if(sucessScore <= 0 || sucessScore > 100){
                                      setState(() {
                                        error = "Select Success Score range between 0 and 100";
                                      });
                                      return;
                                    }

                                    endDate = DateTime.now().add(Duration(days: sessionFreuqencyInDays*sessionDuration));
                                    logFrequencyInDays = progressLogDuration*progressLogFreuqnecyInDays;

                                    await DatabaseService.updateGroupSettings(categoryName, itemOneName, itemTwoName, itemThreeName, sucessScore, endDate, oneSentanceStatement,goalDescription, logFrequencyInDays, Provider.of<UserData>(context, listen: false).userGroupId, _choiceIndex, progressLogFreuqnecyInDays, progressLogDuration, sessionFreuqencyInDays, sessionDuration);

                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )


                      ],)
                  ),
                ),
              ),
            );
          }








        },
      ),
    );
  }
}


class DropDownMenuFrequencyUnitSelection extends StatefulWidget {

  int frequencyUnitScore;

  DropDownMenuFrequencyUnitSelection({this.selectedOptionCallback, this.frequencyUnitScore});

  @required
  Function selectedOptionCallback;

  @override
  _DropDownMenuFrequencyUnitSelectionState createState() => _DropDownMenuFrequencyUnitSelectionState();
}

class _DropDownMenuFrequencyUnitSelectionState extends State<DropDownMenuFrequencyUnitSelection> {
  String dropdownValue;
  int score;
  String initialValue = "Frequency Unit";

  conversionToDays(String value){
    if(value == "day"){
      return score = 1;
    } else if (value == "week"){
      return score = 7;
    } else if (value == "month"){
      return score = 30;
    }
  }

  conversionFromDays(int value){
    if(value == 1){
      return initialValue = "day";
    } else if (value == 7){
      return initialValue = "week";
    } else if (value == 30){
      return initialValue = "month";
    }
    print(value);
  }


  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        focusColor: white,
        elevation: 1,
        hint: Text(
          conversionFromDays(widget.frequencyUnitScore),
          style: TextStyle(color: grey, fontSize: smallSizeText),
        ),
        dropdownColor: white,
        icon: Icon(Icons.arrow_drop_down_rounded,color: grey,),
        style: TextStyle(color: grey, fontSize: smallSizeText),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            widget.selectedOptionCallback(conversionToDays(newValue));
          });
        },
        items: <String>['day', 'week', 'month']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
