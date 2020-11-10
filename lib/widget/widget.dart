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
      // Update the state of the app
      // ...
      // Then close the drawer
      Navigator.pop(context);
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
        feature(context, "Feature 2"),
      ],
    ),
  );
}
