import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class NewDestinationEntryScreen extends StatefulWidget {
  static const routeName = 'new_destination_entry_screen';

  @override
  _NewDestinationEntryScreenState createState() =>
      _NewDestinationEntryScreenState();
}

class _NewDestinationEntryScreenState extends State<NewDestinationEntryScreen> {
  DestinationModel selectedDestination;
  DateTime selectedTravelDate;

  DateTime _dateTime = DateTime.now();

  PlanModel planModel = PlanModel();

  Widget buildPickerItem(DestinationModel destination) {
    return Text(
      '${destination.country}: ${destination.city}',
      style: TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'New Destination Entry',
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('destinations')
              .orderBy('country')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            var destinations =
                (snapshot.data.documents as List<DocumentSnapshot>)
                    .map((e) => DestinationModel.fromSnapshot(e))
                    .toList();

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Expanded(
                    child: Container(
                        child: CupertinoPicker(
                      magnification: 1.0,
                      backgroundColor: Colors.black87,
                      children: destinations
                          .map((s) => buildPickerItem(s))
                          .toList(),
                      itemExtent: 30, //height of each item
                      looping: false,

                      onSelectedItemChanged: (int index) {
                        var destination = DestinationModel.fromSnapshot(
                            snapshot.data.documents[index]);
                        planModel.destinationID = destination.documentID;
                      },
                    )),
                  ),
                ),
                Container(
                  child: buildDatePicker(),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 0.0,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    height: 100,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          RaisedButton(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                            child: Text('Confirm'),
                            textColor: Colors.white,
                            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                            onPressed: () async {
                              
                              // select the first entry by default
                              if (planModel.destinationID == null) {
                                planModel.destinationID = destinations.first.documentID;
                              }

                              // select today's date by default
                              if (planModel.travelDate == null) {
                                planModel.travelDate = _dateTime;
                              }

                              await DataService.createPlan(planModel);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DestinationScreen(
                                        destination: destinations.singleWhere(
                                            (element) =>
                                                element.documentID ==
                                                planModel.destinationID))));
                            },
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }));
  }

  Widget buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        height: 100,
        child: CupertinoDatePicker(
          initialDateTime: _dateTime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) {
            print(dateTime);
            setState(() {
              planModel.travelDate = dateTime;
            });
          },
        ),
      ),
    );
  }
}

