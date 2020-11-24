//import 'package:calendar_app/views/AddEvents.dart';
import 'package:calendar_app/views/AddEvents.dart';
import 'package:calendar_app/widget/widget.dart';
import 'package:flutter/material.dart';
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
  DateTime detailDate;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _navigateAndDisplaySelection(BuildContext context, Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    _scaffoldKey.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text("$result"),duration: Duration(seconds: 2), behavior: SnackBarBehavior.floating,)
      );
  }

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
        key: _scaffoldKey,
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
            detailDate = _calendarController.selectedDay;
            _navigateAndDisplaySelection(
                context,
                AddEvents(
                  detailDate: detailDate,
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
