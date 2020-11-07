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

Widget bottomAppBar(Color color) {
  return BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.home),
          color: Colors.white,
          onPressed: () {
            print("Home");
          }
        ),
        IconButton(
          icon: Icon(Icons.person),
          color: Colors.white,
            onPressed: () {
              print("Acc");
            }
            ),
          ],
        ),
        shape: CircularNotchedRectangle(),
        color: color,
  );
}
