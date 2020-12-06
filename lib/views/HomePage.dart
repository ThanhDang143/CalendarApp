import 'package:calendar_app/views/AddEvents.dart';
import 'package:calendar_app/views/DetailEvents.dart';
import 'package:calendar_app/misc/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController;
  DateTime detailDate;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //  Function navigate display
  _navigateAndDisplaySelection(BuildContext context, Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
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
          // Show Calendar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                calendarController: _calendarController,
                weekendDays: [DateTime.sunday],
                startingDayOfWeek: StartingDayOfWeek.monday,
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                  outsideStyle: TextStyle(
                    color: Colors.black.withOpacity(0.2),
                    fontSize: 12,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  formatButtonTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) =>
                      containerDecor(date, Colors.lightBlue, 50, Colors.white),
                  todayDayBuilder: (context, date, events) => containerDecor(
                      date, Colors.blue.withOpacity(0.25), 50, Colors.white),
                ),
              ),
            ],
          ),
          // Show Events
          Expanded(
            child: checkEvents(),
          ),
          // Sync Notification
          Container(
            width: 0,
            height: 0,
            child: syncNoti(),
          ),
        ],
      ),
      // Show add button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          detailDate = _calendarController.selectedDay;
          _navigateAndDisplaySelection(
            context,
            AddEvents(
              detailDate: detailDate,
            ),
          );
        },
      ),
    );
  }

  // Function check error for showEvents
  checkEvents() {
    if (_calendarController.selectedDay == null) {
      return showEvents(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
    } else {
      return showEvents(
        _calendarController.selectedDay.year,
        _calendarController.selectedDay.month,
        _calendarController.selectedDay.day,
      );
    }
  }

  // Function show Events
  showEvents(int year, month, day) {
    String alarmStatus;

    CollectionReference getData =
        FirebaseFirestore.instance.collection('Events');

    // Function delete events
    deleteData(String id) {
      return getData
          .doc(id)
          .delete()
          .then((value) => print("Deleted"))
          .catchError((error) => print("Failed to delete user: $error"));
    }

    return StreamBuilder<QuerySnapshot>(
stream: getData
    .where(
      'Date',
      isGreaterThanOrEqualTo: DateTime(year, month, day, 00, 00, 00),
      isLessThanOrEqualTo: DateTime(year, month, day, 23, 59, 59),
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
                          DetailEvents(
                            eventsInfo: eventsInfo,
                          ));
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
