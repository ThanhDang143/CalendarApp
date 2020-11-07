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

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Thanhhh's Calendar"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              weekendDays: [DateTime.sunday],
              startingDayOfWeek: StartingDayOfWeek.monday,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                //todayColor: Colors.blueAccent,
                //selectedColor: Theme.of(context).primaryColor.withOpacity(0.5),
                // todayStyle: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white),
                // selectedStyle: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white),
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
                print(date.toString());
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) =>
                    containerDecor(date, Colors.lightBlue, 50, Colors.white),
                todayDayBuilder: (context, date, events) => containerDecor(
                    date, Colors.blue.withOpacity(0.25), 50, Colors.white),
              ),
              calendarController: _calendarController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEvents()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                color: Colors.white,
                onPressed: () {
                  print("Home");
                }),
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
        color: Colors.blue,
      ),
    );
  }
}
