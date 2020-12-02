import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:calendar_app/widget/widget.dart';
import 'package:table_calendar/table_calendar.dart';

import 'AddEvents.dart';

class AllEvents extends StatefulWidget {
  @override
  _AllEventsState createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime detailDate;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(context, "Đặng Văn Thanh", "vanthanh1998@gmail.com"),
      appBar: appBar("Thanhhh's Calendar"),
      body: Column(
        children: [
          Expanded(
            child: showEvents(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateAndDisplaySelection(
            context,
            AddEvents(
              detailDate: DateTime.now(),
            ),
          );
        },
      ),
    );
  }

  _navigateAndDisplaySelection(BuildContext context, Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    if (result == null) {
      return;
    }

    _scaffoldKey.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text("$result"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  showEvents() {
    String alarmStatus;

    CollectionReference getData =
        FirebaseFirestore.instance.collection('Events');

    deleteData(String id) {
      return getData
          .doc(id)
          .delete()
          .then((value) => print("Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: getData.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong :(((');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            if (document.data()['Alarm']) {
              alarmStatus = "Alarm On";
            } else {
              alarmStatus = "Alarm Off";
            }
            return Dismissible(
              background: Card(
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              key: Key(document.data()['ID']),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: InkWell(
                    onTap: () {
                      print("${_calendarController.selectedDay}");
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                      ),
                      // height: 50,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 10,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.event_note,
                              size: 25,
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${document.data()['Events']}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "${document.data()['Date'].toDate().hour.toString().padLeft(2, '0')}:${document.data()['Date'].toDate().minute.toString().padLeft(2, '0')}  ${document.data()['Date'].toDate().day.toString().padLeft(2, '0')}/${document.data()['Date'].toDate().month.toString().padLeft(2, '0')}/${document.data()['Date'].toDate().year.toString().padLeft(2, '0')}"),
                                Text(alarmStatus),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              onDismissed: (direction) {
                deleteData(document.data()['ID']);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
