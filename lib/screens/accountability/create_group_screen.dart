import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/group_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/functions.dart';
import 'package:vastermind/utilities/widgets.dart';

class CreateGroupScreen extends StatefulWidget {
  static final id = "create_group_screen";

  CreateGroupScreen({this.callbackToGroupSelectionScreen});

  @required
  Function callbackToGroupSelectionScreen;

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKeyOne = GlobalKey<FormState>();
  final _formKeyTwo = GlobalKey<FormState>();
  final _formKeyThree = GlobalKey<FormState>();
  bool _isLoading = false;
  List<String> _groupMembers = List<String>();
  String error = "";

  _submitOne(){
    if (_formKeyOne.currentState.validate()){
      _formKeyOne.currentState.save();


      if (categoryName.isEmpty){
        setState(() {
          error = "Choose category to proceed";
        });
        return;
      }

      setState(() {
        currentStage = 2;
        error ="";
      });
    }

  }
  _submitTwo(){
    if (_formKeyTwo.currentState.validate()){
      _formKeyTwo.currentState.save();

      setState(() {
        currentStage = 3;
        error ="";
      });
    }

  }
  _submitThree() async {

      if (_formKeyThree.currentState.validate() && !_isLoading) {
        _formKeyThree.currentState.save();


        setState(() {
          _isLoading = true;
        });


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
            error = "Select valid Success Score goal range. Must be between 0 and 100";
          });
          return;
        }


        endDate = DateTime.now().add(Duration(days: sessionFreuqencyInDays*sessionDuration));
        Timestamp endDateTimestamp = Timestamp.fromDate(endDate);
        logFrequencyInDays = progressLogDuration*progressLogFreuqnecyInDays;

        _groupMembers = List<String>();
        _groupMembers
            .add(Provider.of<UserData>(context, listen: false).currentUserId);

        var groupId = await DatabaseService.createGroup(categoryName, itemOneName, itemTwoName, itemThreeName, sucessScore, endDateTimestamp, logFrequencyInDays, oneSentanceStatement, goalDescription, Provider.of<UserData>(context, listen: false).currentUserId, _groupMembers, _choiceIndex, progressLogFreuqnecyInDays, progressLogDuration, sessionFreuqencyInDays, sessionDuration);

        Group newGroup  = await DatabaseService.getAllGroupDetails(groupId).then((value) => Group.fromDoc(value));

        widget.callbackToGroupSelectionScreen(groupId);

        Provider.of<UserData>(context, listen:false).updateGroupDetails(newGroup);

        error ="";
        Navigator.pop(context);
        Navigator.pop(context);

      }

    }





  int currentStage = 1;



  String oneSentanceStatement;
  String goalDescription;
  String categoryName = "";

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

  final _choiceTitles = ["Fitness",'Learning a habit','Learning a skill',"Happiness", "Personal Growth", 'Side Hustle', 'Relationships',
    'Study', "Other"];

  final _choiceIcons =[Icons.directions_run, Icons.alarm_on_rounded, Icons.architecture_rounded, Icons.tag_faces_rounded, Icons.show_chart_rounded, Icons.work_rounded, Icons.people_rounded, Icons.book_rounded, Icons.add
  ];

  int _choiceIndex;


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
                        foregroundColor: _choiceIndex == index ? white : grey,
                        child: Icon(_choiceIcons[index]),
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

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: SecondaryAppBar(title: currentStage ==  1 ? "Step 1: Set Goal" : currentStage ==2 ? "Step 2: Execution Plan" : "Step 3: Additional Details" ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox.shrink(),
              Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if(error.isNotEmpty)Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(error, style: TextStyle(color: Colors.red, fontSize: smallSizeText),),
                        ],
                      ),
                      currentStage == 1
                          ? Form(
                              key: _formKeyOne,
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Text(
                                    "Note: Due to temporary limitations, you are only allowed to enroll in 1 group at a time. If you create a new group, you will automatically leave your current group",
                                    style: TextStyle(color: grey, fontSize: smallSizeText),
                                  ),
                                  Text(""),
                                  Text(
                                    "Describe the intention and purpose behind this group. What are you trying to achieve?",
                                    style: TextStyle(color: grey, fontSize: smallSizeText),
                                  ),
                                  TextFormField(
                                    style: TextStyle(color: grey, fontSize: midSizeText),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    maxLength: 25,
                                    initialValue: oneSentanceStatement,
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
                                    initialValue: goalDescription,
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

                                ],
                              ),
                            )
                          : currentStage == 2
                              ? Form(key: _formKeyTwo,
                                    child:Column(
                                      children: [



                                        Text(
                                          "Identify 3 actionable items that will allow you to achieve the goal or master the habit",
                                          style: TextStyle(color: grey, fontSize: smallSizeText),
                                        ),
                                        TextFormField(
                                          initialValue: itemOneName,
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
                                          initialValue: itemTwoName,
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
                                          initialValue: itemThreeName,
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

                                      ],
                                    ))
                              : Form(key: _formKeyThree,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Identify how much time you will need to achive the goal. After that time, the group will expire.",
                                                style: TextStyle(color: grey, fontSize: smallSizeText),
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
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
                                                    child: DropDownMenuFrequencyUnitSelection((input){
                                                      sessionFreuqencyInDays = input;
                                                    }),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
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
                                                        labelStyle: TextStyle(color: grey, fontSize: smallSizeText),
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
                                                    child: DropDownMenuFrequencyUnitSelection((logFrequencyDays){
                                                      progressLogFreuqnecyInDays = logFrequencyDays;
                                                    }),
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
                                          )),
                      Column(
                        children: [
                          SizedBox(height: 20,),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ButtonNoFill(
                                    title: "Cancel",
                                    textSize: smallSizeText,
                                    function: () {
                                      Navigator.of(context).pop();
                                    }),
                              ),
                              Expanded(
                                child: FilledSecondaryButton(
                                    top: 0,
                                    title: currentStage != 3 ? "Next" : "Create Group",
                                    color: lightBlue,
                                    buttonSize: "mid",
                                    function: currentStage == 1 ? _submitOne : currentStage == 2 ? _submitTwo : _submitThree),
                              ),

                            ],
                          ), currentStage > 1 ? ButtonNoFill(
                            title: "<-Go Step Back",
                            textSize: smallSizeText,
                            function: (){
                              setState(() {
                                currentStage --;
                                error ="";
                              });
                            },
                          ) : SizedBox()
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}




class DropDownMenuFrequencyUnitSelection extends StatefulWidget {
  DropDownMenuFrequencyUnitSelection(this.selectedOptionCallback);

  @required
  Function selectedOptionCallback;

  @override
  _DropDownMenuFrequencyUnitSelectionState createState() => _DropDownMenuFrequencyUnitSelectionState();
}

class _DropDownMenuFrequencyUnitSelectionState extends State<DropDownMenuFrequencyUnitSelection> {
  String dropdownValue;
  int score;

  conversionToDays(String value){
    if(value == "day"){
      return score = 1;
    } else if (value == "week"){
      return score = 7;
    } else if (value == "month"){
      return score = 30;
    }
  }


  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        focusColor: white,
        elevation: 1,
        hint: Text(
          "Frequency",
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
