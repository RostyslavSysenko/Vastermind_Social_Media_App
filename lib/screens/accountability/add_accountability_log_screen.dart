import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vastermind/models/task_model.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/widgets.dart';

class AddAccountabilityEntryScreen extends StatefulWidget {
  static final String id = "add_accountability_entry_screen";

  String actionItemOneName = "ActionItemOne";
  String actionItemTwoName = "ActionItemTwo";
  String actionItemThreeName = "ActionItemThree";

  double actionItemOneScore = 0;
  double actionItemTwoScore = 0;
  double actionItemThreeScore = 0;

  String note = "";
  DateTime date = DateTime.now();

  Function callbackToLogScreen;

  FocusNode focusNode;

  AddAccountabilityEntryScreen({this.callbackToLogScreen, this.actionItemOneName, this.actionItemTwoName,this.actionItemThreeName});

  @override
  _AddAccountabilityEntryScreenState createState() =>
      _AddAccountabilityEntryScreenState();
}

class _AddAccountabilityEntryScreenState
    extends State<AddAccountabilityEntryScreen> {

  getTotalScore(double progressScoreOne, double progressScoreTwo,
      double progressScoreThree) {
    double totalPointsScore =
        progressScoreOne + progressScoreTwo + progressScoreThree;
    double totalAvaialbePoints = 9;
    double achievementScore = totalPointsScore / totalAvaialbePoints;

    return achievementScore *100;
  }



  @override
  void initState() {
    super.initState();
    widget.focusNode = FocusNode();
    showKeyboard();
  }

  void showKeyboard() {
    widget.focusNode.requestFocus();
  }

  void dismissKeyboard() {
    widget.focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            //detects the presence of keyboard
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //ButtonNoFill(function: (){},textSize: midSizeText,title: "Save",),
                FilledSecondaryButton(
                    title: "save",
                    buttonSize: "large",
                    top: 0,
                    color: lightBlue,
                    function: () {
                      widget.callbackToLogScreen(widget.actionItemOneScore, widget.actionItemTwoScore, widget.actionItemThreeScore, widget.note, widget.date,getTotalScore(widget.actionItemOneScore, widget.actionItemTwoScore, widget.actionItemThreeScore));
                    }


                      ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.actionItemOneName,
                      style: TextStyle(color: grey, fontSize: smallSizeText),
                    ),
                    DropDownMenuScoreLog((itemOneScore) {
                      widget.actionItemOneScore = itemOneScore;
                    }),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.actionItemTwoName,
                      style: TextStyle(color: grey, fontSize: smallSizeText),
                    ),
                    DropDownMenuScoreLog((itemTwoScore) {
                      widget.actionItemTwoScore = itemTwoScore;
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.actionItemThreeName,
                      style: TextStyle(color: grey, fontSize: smallSizeText),
                    ),
                    DropDownMenuScoreLog((itemThreeScore) {
                      widget.actionItemThreeScore = itemThreeScore;
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(color: grey, fontSize: smallSizeText),
                    ),
                    DropDownMenuDate((date) {
                      widget.date = date;
                    }),
                  ],
                ),
              ],
            ),
            //Text("Notes", style: TextStyle(fontSize: midSizeText, color: lightBlue),),
            TextField(
              onChanged: (newNote) {
                widget.note = newNote;
              },
              focusNode: widget.focusNode,

              maxLines: 2,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.multiline,
              maxLength: 100,
              style: TextStyle(fontSize: midSizeText, color: grey),
              decoration:
              //in case i have problems with decoration box , use input decoration collapsed
              // InputDecoration.collapsed(
              //   hintText: "Enter your Notes here",
              //   border: OutlineInputBorder(
              //       borderSide: BorderSide(color: lightBlue)),
              //   hintStyle: TextStyle(color: grey, fontSize: smallSizeText),
              // ),
              InputDecoration(
                hintText: "Add quick note",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: lightBlue)),
                hintStyle: TextStyle(color: grey, fontSize: smallSizeText),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

class DropDownMenuScoreLog extends StatefulWidget {
  DropDownMenuScoreLog(this.selectedOptionCallback);

  @required
  Function selectedOptionCallback;

  @override
  _DropDownMenuScoreLogState createState() => _DropDownMenuScoreLogState();
}

class _DropDownMenuScoreLogState extends State<DropDownMenuScoreLog> {
  String dropdownValue;
  double score;

  calculateScore(String str) {
    double score = 0;
    if (str == "None") {
      score = 0;
    } else if (str == "Somewhat") {
      score = 1;
    } else if (str == "Almost") {
      score = 2;
    } else if (str == "Excellent") {
      score = 3;
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      focusColor: white,
      elevation: 1,
      hint: Text(
        "Score",
        style: TextStyle(color: lightBlue, fontSize: smallSizeText),
      ),
      dropdownColor: white,
      icon: Icon(Icons.arrow_drop_down_rounded,color: grey,),
      style: TextStyle(color: lightBlue, fontSize: smallSizeText),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          score = calculateScore(dropdownValue);
          widget.selectedOptionCallback(score);
        });
      },
      items: <String>['None', 'Somewhat', 'Almost', 'Excellent']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDownMenuDate extends StatefulWidget {
  DropDownMenuDate(this.selectedOptionCallback);

  @required
  Function selectedOptionCallback;

  @override
  _DropDownMenuDateState createState() => _DropDownMenuDateState();
}

class _DropDownMenuDateState extends State<DropDownMenuDate> {
  String dropdownValue;
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,

      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      focusColor: white,
      elevation: 1,
      icon: Icon(Icons.arrow_drop_down_rounded,color: grey,),
      hint: Text(
        "Today",
        style: TextStyle(color: lightBlue, fontSize: smallSizeText),
      ),
      dropdownColor: white,
      style: TextStyle(color: lightBlue, fontSize: smallSizeText),
      onChanged: (String newValue) async {

        setState(() {
          dropdownValue = newValue;
        });

        if (dropdownValue == "Other"){
          await _selectDate(context);
        }
        if (dropdownValue == "Today"){
          selectedDate = DateTime.now();
        }


        widget.selectedOptionCallback(selectedDate);

      },
      items: <String>['Today', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
