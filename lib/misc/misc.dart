import 'package:calendar_app/views/Auth/SignIn.dart';
import 'package:calendar_app/views/Main/AllEvents.dart';
import 'package:calendar_app/views/Main/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../views/Main/AllEvents.dart';

Widget appBar(String title) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
  );
}

Widget containerDecor(
    DateTime date, Color boxColor, double borderRadius, Color textColor) {
  return Container(
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: boxColor,
          //shape: boxShape,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Text(
        date.day.toString(),
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ));
}

Widget navigator(BuildContext context, Widget otherScreen, String featureName) {
  return ListTile(
    title: Text(featureName),
    onTap: () {
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => otherScreen),
      );
    },
  );
}

Widget signOutWidget(
    BuildContext context, Widget otherScreen, String featureName) {
  return ListTile(
    title: Text(featureName),
    onTap: () {
      signOut();

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => otherScreen),
      );
    },
  );
}

Widget drawer(BuildContext context) {

    return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
        accountName: Text('${FirebaseAuth.instance.currentUser.displayName}'),
          accountEmail: Text('${FirebaseAuth.instance.currentUser.email}'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
          ),
        ),
        navigator(context, HomePage(), 'Home'),
        navigator(context, AllEvents(), 'All Events'),
        signOutWidget(context, SignIn(), 'Sign Out')
      ],
    ),
  );
}

Widget card(BuildContext context, String previewEvents) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
      side: BorderSide(color: Colors.grey),
    ),
    child: Container(
      height: 50,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 10,
            alignment: Alignment.center,
            child: Icon(
              Icons.notifications_none,
              size: 25,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 7 / 10,
            child: Text(previewEvents),
          ),
        ],
      ),
    ),
  );
}

class EventsInfo {
  String iD;
  DateTime eventsDate = DateTime.now();
  bool alarm;
  String eventsTitle;
  String eventsDes;
  int alarmID;

  EventsInfo(this.iD, this.eventsDate, this.alarm, this.eventsTitle,
      this.eventsDes, this.alarmID);
}

int alarmID() {
  int x = Timestamp.now().seconds - Timestamp.now().nanoseconds;
  return x;
}

setAlarm(int id, String title, des, DateTime eventsTime) async {
  print('Set Alarm $id');

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channelId',
    'channelName',
    'channelDescription',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  NotificationDetails notificationDetails =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(
    id,
    title,
    des,
    eventsTime,
    notificationDetails,
  );
}

deleteAlarm(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

syncNoti() {
  CollectionReference getData = FirebaseFirestore.instance.collection('Events');

  return StreamBuilder<QuerySnapshot>(
    stream: getData
        .where(
          'Date',
          isGreaterThanOrEqualTo: DateTime.now(),
        )
        .orderBy('Date')
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong :(((');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading...");
      }

      return ListView(
        children: snapshot.data.docs.map((DocumentSnapshot document) {
          if (document.data()['Alarm'] &&
              !document.data()['Date'].toDate().isBefore(DateTime.now())) {
            setAlarm(
              document.data()['AlarmID'],
              document.data()['Events'],
              document.data()['Description'],
              document.data()['Date'].toDate(),
            );
          }
          return Container();
        }).toList(),
      );
    },
  );
}

//Auth
bool isValidEmail(value) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value);
}

Widget alertSignInButton(BuildContext context) {
  return FlatButton(
    child: Text("Sign In"),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
}

Widget alertTryAgainButton(BuildContext context) {
  return FlatButton(
    child: Text("Try Again"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}

showAlertDialog(
    BuildContext context, String title, String message, Widget action) {
  AlertDialog alert = AlertDialog(
    title: Text("$title"),
    content: Text("$message"),
    actions: [
      action,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future signOut() async {
  try {
    return await FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future signUp(BuildContext context, String email, String password,
    String displayName) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    showAlertDialog(
      context,
      'Sign Up',
      'Success',
      alertSignInButton(context),
    );
    FirebaseAuth.instance.currentUser.updateProfile(displayName: displayName);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showAlertDialog(
        context,
        'Sign Up',
        'The password provided is too weak!',
        alertTryAgainButton(context),
      );
    } else if (e.code == 'email-already-in-use') {
      showAlertDialog(
        context,
        'Sign Up',
        'The account already exists for that email!',
        alertTryAgainButton(context),
      );
    }
  } catch (e) {
    showAlertDialog(
      context,
      'Sign Up',
      'Oh No!!! We hava an error!',
      alertTryAgainButton(context),
    );
  }
}

Future signIn(BuildContext context, String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  } catch (e) {
    showAlertDialog(
      context,
      'Sign In',
      'Oh No!!! Check your email or password!',
      alertTryAgainButton(context),
    );
  }
}

Widget checkLogin() {
  User _user = FirebaseAuth.instance.currentUser;

  //Check login
  if (_user != null) {
    return HomePage();
  }
  return SignIn();
}