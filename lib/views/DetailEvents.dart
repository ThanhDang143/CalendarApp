import 'package:calendar_app/misc/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailEvents extends StatefulWidget {
  final EventsInfo eventsInfo;
  DetailEvents({Key key, @required this.eventsInfo}) : super(key: key);

  @override
  _DetailEventsState createState() => _DetailEventsState(eventsInfo);
}

class _DetailEventsState extends State<DetailEvents> {
  EventsInfo eventsInfo;
  _DetailEventsState(this.eventsInfo);

  DateTime detailDate;
  bool isSwitched = false;
  String alarm;

  TextEditingController _eventsTitleController;
  TextEditingController _eventsDesController;

  TimeOfDay selectedTime;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _nodeTitle = FocusNode();

  @override
  void initState() {
    super.initState();
    _eventsTitleController =
        TextEditingController(text: eventsInfo.eventsTitle);
    _eventsDesController = TextEditingController(text: eventsInfo.eventsDes);
    detailDate = eventsInfo.eventsDate;
    selectedTime = TimeOfDay(
      hour: eventsInfo.eventsDate.hour,
      minute: eventsInfo.eventsDate.minute,
    );
    isSwitched = eventsInfo.alarm;
    if (isSwitched) {
      alarm = "Alarm On";
    } else {
      alarm = "Alarm Off";
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: detailDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != detailDate) {
      setState(() {
        detailDate = picked;
      });
    }
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

  Widget view() {
    return Column(
      children: [
        Card(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            focusNode: _nodeTitle,
            controller: _eventsTitleController,
            decoration: InputDecoration(
                hintText: "Events", border: OutlineInputBorder()),
          ),
        ),
        Card(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: _eventsDesController,
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
                        Icons.calendar_today,
                        size: 25,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 7 / 10,
                      child: Text(
                        "Select Date \n${detailDate.day.toString().padLeft(2, '0')}/${detailDate.month.toString().padLeft(2, '0')}/${detailDate.year}",
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.grey),
            ),
            child: InkWell(
              onTap: () {
                _selectTime(context);
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
                        "$alarm \n${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",
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
                            if (isSwitched) {
                              alarm = "Alarm On";
                            } else {
                              alarm = "Alarm Off";
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar("Edit Events"),
      body: view(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_eventsTitleController.text.isEmpty) {
            _scaffoldKey.currentState
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Event Title Can't Empty!!!"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            FocusScope.of(context).requestFocus(_nodeTitle);
          } else {
            Navigator.pop(context, "Updated!");

            CollectionReference update =
                FirebaseFirestore.instance.collection('Events');

            DateTime eventsTime = DateTime(detailDate.year, detailDate.month,
                detailDate.day, selectedTime.hour, selectedTime.minute);

            if (isSwitched) {
              return update.doc(eventsInfo.iD)
                ..update({'Events': _eventsTitleController.text})
                ..update({'Description': _eventsDesController.text})
                ..update({'Alarm': isSwitched})
                ..update({'Date': eventsTime})
                    .then((value) => deleteAlarm(eventsInfo.alarmID))
                    .then((value) => setAlarm(
                        eventsInfo.alarmID,
                        _eventsTitleController.text,
                        _eventsDesController.text,
                        eventsTime))
                    .catchError(
                        (error) => print("Failed to update user: $error"));
            } else {
              return update.doc(eventsInfo.iD)
                ..update({'Events': _eventsTitleController.text})
                ..update({'Description': _eventsDesController.text})
                ..update({'Alarm': isSwitched})
                ..update({'Date': eventsTime})
                    .then((value) => deleteAlarm(eventsInfo.alarmID))
                    .catchError(
                        (error) => print("Failed to update user: $error"));
            }
          }
        },
      ),
    );
  }
}
