import 'package:flutter/material.dart';

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

Widget feature(BuildContext context, String featureName) {
  return ListTile(
    title: Text(featureName),
    onTap: () {
      Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => screenx),
      // );
      //Navigator.pop(context);
    },
  );
}

Widget drawer(BuildContext context, String usn, String email) {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(usn),
          accountEmail: Text(email),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
          ),
        ),
        feature(context, "Feature 1"),
        //feature(context, "Feature 2",),
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

class CreateEventsData {
  DateTime createEventsDate = DateTime.now();
  TimeOfDay createEventsTime = TimeOfDay.now();
  String eventsTitle;
  String eventsDes;

  CreateEventsData(this.createEventsDate, this.createEventsTime, this.eventsTitle, this.eventsDes);
}
