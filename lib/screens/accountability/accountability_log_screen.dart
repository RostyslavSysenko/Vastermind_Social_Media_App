import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/group_model.dart';
import 'package:vastermind/models/task_model.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/functions.dart';
import 'package:vastermind/utilities/widgets.dart';

import 'add_accountability_log_screen.dart';

class UpdateAccountabilityProgressScreen extends StatefulWidget {
  static final String id = "accountability_update_progress_screen";
  @required
  String userId;
  @required
  Group group;


  UpdateAccountabilityProgressScreen({this.userId, this.group});

  @override
  _UpdateAccountabilityProgressScreenState createState() =>
      _UpdateAccountabilityProgressScreenState();
}

class _UpdateAccountabilityProgressScreenState
    extends State<UpdateAccountabilityProgressScreen> {
  double _actionItemOneScore;
  double _actionItemTwoScore;
  double _actionItemThreeScore;
  String _note;
  DateTime _date;
  double _totalScore;
  List<Task> logs = [];

  @override
  void initState() {
    super.initState();
    getLogs(context);

  }

  getLogs(BuildContext context) async {
    QuerySnapshot logsSnapshot = await DatabaseService.getLogs(
        Provider.of<UserData>(context, listen: false).currentUserId,
        widget.group.id);

    List<DocumentSnapshot> logsDocs = logsSnapshot.documents;

    logs = [];

    for (var logDoc in logsDocs) {
      Task log = Task.fromDoc(logDoc);
      logs.add(log);
    }
    return logs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: "Log History"),
      body: FutureBuilder(
        future: getLogs(context),
        builder: (context, snap) {
          if (snap.hasData == false) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            body: snap.data.length == 0
                ? Container(child: Center(child: Text("Currently no entries", style: TextStyle(color: grey, fontSize: smallSizeText),)))
                : Container(
              width: MediaQuery.of(context).size.width,
                  child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/5,),
                      Expanded(child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(child: Text(widget.group.actionOneName, style: TextStyle(color: lightBlue, fontSize: smallSizeText),)),
                          Container(child: Text(widget.group.actionTwoName, style: TextStyle(color: lightBlue, fontSize: smallSizeText),)),
                          Container(child: Text(widget.group.actionThreeName, style: TextStyle(color: lightBlue, fontSize: smallSizeText),)),
                          SizedBox(width: 20,)
                        ],
                      ),
                      flex: 4,),
                      SizedBox(width: MediaQuery.of(context).size.width/7,)
                    ],
                  ),

                ),
              //Divider(),
              Expanded(child: ListViewCust(tasks: logs, targetSuccessScore: widget.group.sucessTarget,)),
              ],
            ),
                ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: Container(
              height: MediaQuery.of(context).size.height/12,
              child: BottomAppBar(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 30,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      (logs.length == 1) ? Text(
                        "${logs.length} log ${RepeatingFunctions.getSuccessScore(logs, "accountability")} | ${widget.group.groupEndDate.toDate().difference(DateTime.now()).inDays} days to go",
                        style: TextStyle(color: lightBlue, fontSize: smallSizeText),
                      ) : (logs.length > 1) ? Text(
                        "${logs.length} logs ${RepeatingFunctions.getSuccessScore(logs, "accountability")} | ${widget.group.groupEndDate.toDate().difference(DateTime.now()).inDays} days to go",
                        style: TextStyle(color: lightBlue, fontSize: smallSizeText),
                      ) : Text(
                        "${logs.length} logs | ${widget.group.groupEndDate.toDate().difference(DateTime.now()).inDays} days to go",
                        style: TextStyle(color: lightBlue, fontSize: smallSizeText),
                      )

                    ],
                  ),
                ),
                shape: CircularNotchedRectangle(),
                // color: ,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0))),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => AddAccountabilityEntryScreen(
                      actionItemOneName: widget.group.actionOneName,
                        actionItemTwoName: widget.group.actionTwoName,
                        actionItemThreeName: widget.group.actionThreeName,
                        callbackToLogScreen:
                            (scoreOne, scoreTwo, scoreThree, notes, date, totalScore) async {
                          _actionItemOneScore = scoreOne;
                          _actionItemTwoScore = scoreTwo;
                          _actionItemThreeScore = scoreThree;
                          _note = notes;
                          _date = date;
                          _totalScore = totalScore;

                          Task newTask = Task(
                              date: _date,
                              progressScoreOne: _actionItemOneScore,
                              progressScoreTwo: _actionItemTwoScore,
                              progressScoreThree: _actionItemThreeScore,
                              note: _note,
                          totalScore: _totalScore);

                          Task repeatedLog;
                          bool repeated = false;
                          logs.forEach((log) {
                            if (newTask.date.month == log.date.month &&
                                newTask.date.day == log.date.day &&
                                newTask.date.year == log.date.year) {
                              repeated = true;
                              repeatedLog = log;
                            }
                          });
                          if(repeated){

                            await DatabaseService.replaceLog(
                                newTask, widget.group.id, widget.userId);
                          } else {
                            await DatabaseService.createLog(
                                newTask, widget.group.id, widget.userId);
                          }
                          setState(() {
                            logs = logs;
                          });

                          Navigator.pop(context);
                        }
                        ));
              },
              backgroundColor: lightBlue,
              child: Icon(
                Icons.add,
                color: white,
              ),
            ),
          );
        },
      ),
    );
  }
}
