import 'package:calendar_app/widget/widget.dart';
import 'package:flutter/material.dart';

class AddEvents extends StatefulWidget {
  @override
  _AddEventsState createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  bool isSwitched = false;
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
                    hintText: 'Event', border: OutlineInputBorder()),
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
                      width: MediaQuery.of(context).size.width * 7/10,
                      child: Text("Alarm on!\n2020-11-13 12:00"),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 8.2/10),
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
            )
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
