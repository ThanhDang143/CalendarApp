import 'package:calendar_app/views/AddEvents.dart';
import 'package:calendar_app/views/DetailEvents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:calendar_app/misc/misc.dart';

class AllEvents extends StatefulWidget {
  @override
  _AllEventsState createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
            AddEvents(detailDate: DateTime.now()),
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
    ScrollController _listController;

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
      stream: getData.orderBy('Date').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong :(((');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        return ListView(
          controller: _listController,
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            if (document.data()['Alarm']) {
              alarmStatus = "Alarm On";
            } else {
              alarmStatus = "Alarm Off";
            }

            // Get data for Detail Events
            EventsInfo eventsInfo = EventsInfo(
              document.data()['ID'],
              document.data()['Date'].toDate(),
              document.data()['Alarm'],
              document.data()['Events'],
              document.data()['Description'],
              document.data()['AlarmID'],
            );

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
                      _navigateAndDisplaySelection(
                        context,
                        DetailEvents(eventsInfo: eventsInfo),
                      );
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
                deleteAlarm(document.data()['AlarmID']);
                deleteData(document.data()['ID']);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
