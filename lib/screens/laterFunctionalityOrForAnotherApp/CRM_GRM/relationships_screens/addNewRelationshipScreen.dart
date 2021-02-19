import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/widgets.dart';

class AddRelationshipScreen extends StatefulWidget {
  @required Function callBackToCommunityScreen;

  //common
  String name;
  String action;
  DateTime actionDate;
  String relationshipType;

  FocusNode focusNode;

  AddRelationshipScreen(this.callBackToCommunityScreen);

  @override
  _AddRelationshipScreenState createState() => _AddRelationshipScreenState();
}

class _AddRelationshipScreenState extends State<AddRelationshipScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {

    super.initState();

    widget.focusNode = FocusNode();
    showKeyboard();
  }

  List<Widget> list = [
    Tab(text: "CRM"),
    Tab(text: "Game"),
  ];

  void showKeyboard() {
    widget.focusNode.requestFocus();
  }

  void dismissKeyboard() {
    widget.focusNode.unfocus();
  }

  bool moreOptionsActiveCRM = false;

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
                        print(widget.relationshipType);
                        print(widget.action);
                        print(widget.name);
                        print(widget.actionDate);
                        if (widget.actionDate != null && widget.name != null && widget.name.isNotEmpty && widget.action != null && widget.relationshipType != null){
                          print(widget.relationshipType);
                          print(widget.action);
                          print(widget.name);
                          print(widget.actionDate);
                          widget.callBackToCommunityScreen(widget.name, widget.action, widget.relationshipType, widget.actionDate);
                        }

                      }),
                ],
              ),
              Column(
                children: [
                  TextField(
                    onChanged: (newNote) {
                      widget.name = newNote;
                    },

                    focusNode: widget.focusNode,
                    autocorrect: false,
                    maxLines: 1,
                    maxLength: 20,
                    style:
                        TextStyle(fontSize: midSizeText, color: grey),
                    decoration:
                        //in case i have problems with decoration box , use input decoration collapsed
                        // InputDecoration.collapsed(
                        //   hintText: "Enter your Notes here",
                        //   border: OutlineInputBorder(
                        //       borderSide: BorderSide(color: lightBlue)),
                        //   hintStyle: TextStyle(color: grey, fontSize: smallSizeText),
                        // ),
                        InputDecoration(
                      hintText: "Enter name here...",
                      // border: OutlineInputBorder(
                      //     borderSide: BorderSide(color: lightBlue)),
                      hintStyle: TextStyle(
                          color: grey, fontSize: smallSizeText),
                    ),
                  ),
                  Row(
                    children: [

                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: DropDownMenuAction((action) {
                            widget.action = action;
                          }),
                        ),
                      ),
                      Expanded(
                        child:
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              child: DropDownMenuActionDateCRM((actionDate) {
                          widget.actionDate = actionDate;
                        }),
                            ),
                      ),
                      Expanded(child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1),
                        child: DropDownMenuRelationshipType((type) {
                          setState(() {
                            widget.relationshipType = type;
                          });

                        }),
                      )),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: (){
                              if(widget.relationshipType != null)
                              setState(() {
                                moreOptionsActiveCRM = !moreOptionsActiveCRM;
                              });
                            },
                            child: widget.relationshipType != null ? Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  moreOptionsActiveCRM ? Text(
                                    "Less",
                                    style: TextStyle(
                                        fontSize: smallSizeText, color: lightBlue),
                                  ) : Text(
                                    "More",
                                    style: TextStyle(
                                        fontSize: smallSizeText, color: lightBlue),
                                  ),
                                  moreOptionsActiveCRM ? Icon(
                                    Icons.arrow_drop_up_rounded,
                                    color: grey,
                                  ) : Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: grey,
                                  )
                                ],
                              ),
                            ) : Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "More",
                                    style: TextStyle(
                                        fontSize: smallSizeText, color: grey),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )

                  //Expandable more options
                ],
              ),
            moreOptionsActiveCRM ? SizedBox(
            height: MediaQuery.of(context).size.height/3,
            child: widget.relationshipType == "Game" ? Column(
              children: [
                Text("more options coming soon"),

              ],
            ) :
            Column(
              children: [
                Text("more options coming soon"),

              ],
            )
          ) : SizedBox(
              height: MediaQuery.of(context).size.height/5,
            ),
        ],




      ),
    ));
  }
}


class DropDownMenuRelationshipType extends StatefulWidget {
  DropDownMenuRelationshipType(this.selectedOptionCallback);

  @required
  Function selectedOptionCallback;

  @override
  _DropDownMenuRelationshipType createState() => _DropDownMenuRelationshipType();
}



class _DropDownMenuRelationshipType extends State<DropDownMenuRelationshipType> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        autofocus: true,
        value: dropdownValue,
        focusColor: white,
        elevation: 1,
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: grey,
        ),
        hint: Text(
          "Type",
          style: TextStyle(color: lightBlue, fontSize: smallSizeText),
        ),
        dropdownColor: white,
        style: TextStyle(color: lightBlue, fontSize: smallSizeText),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            widget.selectedOptionCallback(dropdownValue);
          });
        },
        items: <String>['Game', 'CRM']
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



class DropDownMenuAction extends StatefulWidget {
  DropDownMenuAction(this.selectedOptionCallback);

  @required
  Function selectedOptionCallback;

  @override
  _DropDownMenuActionCRM createState() => _DropDownMenuActionCRM();
}



class _DropDownMenuActionCRM extends State<DropDownMenuAction> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        focusColor: white,
        elevation: 1,
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: grey,
        ),
        hint: Text(
          "Action",
          style: TextStyle(color: lightBlue, fontSize: smallSizeText),
        ),
        dropdownColor: white,
        style: TextStyle(color: lightBlue, fontSize: smallSizeText),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            widget.selectedOptionCallback(newValue);
          });
        },
        items: <String>['Meet', 'Call', 'Message', 'Ping']
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

class DropDownMenuActionDateCRM extends StatefulWidget {
  DropDownMenuActionDateCRM(this.selectedOptionCallback);

  @required
  Function selectedOptionCallback;

  @override
  _DropDownMenuActionDateCRMState createState() =>
      _DropDownMenuActionDateCRMState();
}

class _DropDownMenuActionDateCRMState extends State<DropDownMenuActionDateCRM> {
  String dropdownValue;
  DateTime selectedDate;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,

      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        focusColor: white,
        elevation: 1,
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          color: grey,
        ),
        hint: Text(
          "Date",
          style: TextStyle(color: lightBlue, fontSize: smallSizeText),
        ),
        dropdownColor: white,
        style: TextStyle(color: lightBlue, fontSize: smallSizeText),
        onChanged: (String newValue) async {
          setState(() {
            dropdownValue = newValue;
          });

          if (dropdownValue == "Other") {
            await _selectDate(context);
          }
          if (dropdownValue == "Today") {
            selectedDate = DateTime.now();
          }
          if (dropdownValue == "Tomorrow") {
            selectedDate = DateTime.now().add(Duration(days: 1));
          }
          if (dropdownValue == "In 1 Week") {
            selectedDate = DateTime.now().add(Duration(days: 7));
          }

          widget.selectedOptionCallback(selectedDate);
        },
        items: <String>["Today", 'Tomorrow', "In 1 Week", 'Other']
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
