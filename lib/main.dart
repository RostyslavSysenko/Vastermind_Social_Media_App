import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:vastermind/screens/accountability/accountability_dashboard_screen.dart';
import 'package:vastermind/screens/accountability/accountability_group_settings_screen.dart';
import 'package:vastermind/screens/accountability/create_group_screen.dart';
import 'package:vastermind/screens/community/profileRelationships/connections_screen.dart';
import 'package:vastermind/screens/community/profileRelationships/followers_screen.dart';
import 'package:vastermind/screens/community/profileRelationships/following_screen.dart';
import 'package:vastermind/screens/community/community_screen.dart';
import 'package:vastermind/screens/accountability/message_screen.dart';
import 'package:vastermind/services/databaseService.dart';
import 'package:vastermind/utilities/constants.dart';
import 'package:vastermind/screens/authentication/login_screen.dart';
import 'package:vastermind/screens/authentication/sign_up_screen.dart';
import "package:flutter/services.dart";

import 'models/user_data.dart';
import 'models/user_model.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final initializationSettingsAndroid = AndroidInitializationSettings("appstore");

  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);


  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      });


  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  //this block of code is responcible for keeping user signed in
  Widget _getScreenID() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder:(BuildContext context, snapshot) {
        if (snapshot.hasData) {
          //this thing provides the user id for the whole entire app using provider notifier
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
        return AccountabilityDashboardScreen();
      } else {
        return SignUpScreen();

      }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Australia/Sydney"));


    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('repeating channel id',
        'Consistency Is Key', 'Time to log your progress to ensure you stay on track towards your ambitious goal');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.periodicallyShow(0, 'Consistency Is Key',
        'Time to log your progress to ensure you stay on track towards your ambitious goal', RepeatInterval.daily, platformChannelSpecifics,
        androidAllowWhileIdle: true);

    //setting preffered orientation for the app
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'Vastermind',
        debugShowCheckedModeBanner: false,
        home: _getScreenID(),
        theme: ThemeData(primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(color: lightBlue),
        buttonTheme: ButtonThemeData(
          minWidth: 0,
        )),
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          CommunityScreen.id: (context) => CommunityScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          AccountabilityDashboardScreen.id: (context) => AccountabilityDashboardScreen(),
          AccountabilityGroupSettingsScreen.id: (context) => AccountabilityGroupSettingsScreen(),
          CreateGroupScreen.id: (context) => CreateGroupScreen(),
        },
      ),
    );
  }
}
