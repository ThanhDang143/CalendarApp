import 'package:flutter/material.dart';

Widget appBar(String title) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
  );
}

Widget containerDecor(DateTime date, Color boxColor, double borderRadius, Color textColor) {
  return Container(
    margin: EdgeInsets.all(10),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: boxColor,
      //shape: boxShape,
      borderRadius: BorderRadius.circular(borderRadius)
    ),
    child: Text(
      date.day.toString(),
      style: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    )
  );
}

Widget aaa() {
  return Scaffold();
}
