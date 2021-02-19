import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/models/user_data.dart';
import 'package:vastermind/models/user_model.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/utilities/widgets.dart';

class ChatScreen extends StatefulWidget {
  static final id = "message_screen";
  @required final groupId;
  @required final focus;

  ChatScreen({this.groupId, this.focus});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  String messageText;
  User user;
  TextEditingController messageTextController = TextEditingController();

  getCurrUser(BuildContext context) async {
    DocumentSnapshot userDoc = await usersRef
        .document(Provider.of<UserData>(context, listen: false).currentUserId)
        .get();
    User user = User.fromDoc(userDoc);
    return user;
  }

  _clearSearch() {
    print(messageTextController);
    print(messageText);
    messageTextController.clear();
    setState(() {
      messageText = null;
    });
  }

  _submit() async {
    if (user == null) {
      user = await getCurrUser(context);
      print("setting user");
    }

    if (messageText.isNotEmpty) {
      print(Provider.of<UserData>(context, listen: false).userGroupId);
      groupsRef.document(widget.groupId).collection("messages").add({
        "text": messageText,
        "sender name": user.name,
        "sender id": user.id,
        "timestamp": FieldValue.serverTimestamp()
      });
    }
    _clearSearch();
  }

  // getMessages() async {
  //   final messages = await messagesRef.getDocuments();
  //   for (var message in messages.documents){
  //     print(message.data);
  //
  //   }
  // }

  //stream is an updating list of some class (plural of futures
  void messagesStream() async {
    print("here here here");
    await for (var snapshot in groupsRef.document(user.groupId).collection("messages").snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }



  @override
  void initState() {
    super.initState();
    getCurrUser(context);
    widget.focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(),
            MessagesStream(
              currentGroupId: widget.groupId,
                currUserId: Provider.of<UserData>(context).currentUserId),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      focusNode: widget.focus,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ButtonNoFill(
                    function: _submit,
                    title: "Send",
                    textSize: midSizeText,
                  ),
                ],
              ),
            ),
          ],
        ),
    );

  }
}

class MessagesStream extends StatelessWidget {
  MessagesStream({this.currUserId, this.currentGroupId});

  @required
  final String currUserId;
  final String currentGroupId;

  @override
  Widget build(BuildContext context) {
    bool myMessage = true;
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: [CircularProgressIndicator(backgroundColor: white)],
          );
        } else {
          final messages = snapshot.data.documents;
          List<Widget> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data["text"];
            final messageSenderName = message.data["sender name"];
            final messageSenderId = message.data["sender id"];

            messageSenderId == currUserId
                ? myMessage = true
                : myMessage = false;

            final messageWidget = MessageBubble(
                text: messageText,
                messageSender: messageSenderName,
                myMessage: myMessage);
            messageBubbles.add(messageWidget);
          }
          return Expanded(
              child: ListView(
                reverse: true,
                shrinkWrap: true,

            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: List.from(messageBubbles.reversed),
          ));
        }
      },
      stream: groupsRef.document(currentGroupId).collection("messages").orderBy('timestamp').snapshots(),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.messageSender, this.myMessage});

  @required
  final String text;
  @required
  final String messageSender;
  @required
  final bool myMessage;
  final double radius = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Column(
        crossAxisAlignment:
            myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender,
            style: TextStyle(fontSize: smallSizeText, color: grey),
          ),
          Material(
              borderRadius: myMessage
                  ? BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(radius),
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
              elevation: 3,
              color: myMessage ? lightBlue : white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 7,
                  horizontal: 10,
                ),
                child: myMessage
                    ? Text(
                        "$text",
                        style: TextStyle(fontSize: midSizeText, color: white),
                      )
                    : Text(
                        "$text",
                        style: TextStyle(fontSize: midSizeText, color: grey),
                      ),
              )),
        ],
      ),
    );
  }
}
