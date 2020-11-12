import 'package:calendar_app/widget/widget.dart';
import 'package:flutter/material.dart';

class AddEvents extends StatefulWidget {
  final String text;
  AddEvents({Key key, @required this.text}) : super(key: key);

  @override
  _AddEventsState createState() => _AddEventsState(text);
}

class _AddEventsState extends State<AddEvents> {
  bool isSwitched = false;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null)
      setState(() {
        selectedTime = picked;
      });
  }

  final String text;
  _AddEventsState(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Add Events"),
      body: Container(
        child: Column(
          children: [
            Card(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Events", border: OutlineInputBorder()),
              ),
            ),
            Card(
              child: TextField(
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: 'Description', border: OutlineInputBorder()),
              ),
            ),
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.grey),
                ),
                child: InkWell(
                  onTap: () {
                    _selectTime(context);
                    _selectDate(context);
                  },
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
                          child: Text(
                            "Alarm on!!! \n${selectedTime.hour}:${selectedTime.minute} - ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              (MediaQuery.of(context).size.width * 8.2 / 10),
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                print(isSwitched);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          print("Save");
        },
      ),
    );
  }
}
