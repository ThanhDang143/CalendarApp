//import 'package:calendar_app/views/AddEvents.dart';
import 'package:calendar_app/views/AddEvents.dart';
import 'package:calendar_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  TextEditingController _eventsController;
  List<dynamic> _listEvents;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _eventsController = TextEditingController();
    _listEvents = [];
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<String, dynamic> decodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: drawer(context, "Đặng Văn Thanh", "vanthanh1998@gmail.com"),
        appBar: appBar("Thanhhh's Calendar"),
        body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  events: _events,
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
                          borderRadius: BorderRadius.circular(15)),
                      formatButtonTextStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  onDaySelected: (date, events, _) {
                    setState(() {
                      _listEvents = events;
                    });
                  },
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) =>
                        containerDecor(
                            date, Colors.lightBlue, 50, Colors.white),
                    todayDayBuilder: (context, date, events) => containerDecor(
                        date, Colors.blue.withOpacity(0.25), 50, Colors.white),
                  ),
                  calendarController: _calendarController,
                ),
              ],
            ),
            Expanded(
                child: ListView(
              children: [..._listEvents.map((e) => card(context, e))],
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEvents(
                      text: _calendarController.selectedDay.toString()),
                ));
          },
        )
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {
        //     showDialog(
        //         context: context,
        //         builder: (context) => AlertDialog(
        //               content: TextField(
        //                 controller: _eventsController,
        //               ),
        //               actions: [
        //                 FlatButton(
        //                   child: Text("SAVE"),
        //                   onPressed: () {
        //                     if (_eventsController.text.isEmpty) return;
        //                     setState(() {
        //                       if (_events[_calendarController.selectedDay] !=
        //                           null) {
        //                         _events[_calendarController.selectedDay]
        //                             .add(_eventsController.text);
        //                       } else {
        //                         _events[_calendarController.selectedDay] = [
        //                           _eventsController.text
        //                         ];
        //                       }
        //                       _eventsController.clear();
        //                       Navigator.pop(context);
        //                     });
        //                   },
        //                 )
        //               ],
        //             ));
        //   },
        );
  }
}
