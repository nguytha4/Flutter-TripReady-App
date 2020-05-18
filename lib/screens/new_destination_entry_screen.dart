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
                .collection('destination')
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          child: Text('Confirm'),
                          onPressed: () async {
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 40.0,
                          ),
                        )
                      ],
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

    // // return InputDatePickerFormField(
    // // fieldLabelText: 'Trip Date',
    // // firstDate: DateTime.now().subtract(Duration(days: 365)),
    // // lastDate: DateTime.now().add(Duration(days: 365)));

    // return Padding(
    //   padding: const EdgeInsets.all(18),
    //   child: Theme(
    //     data: ThemeData(primaryColor: Colors.blue),
    //     child: TextFormField(
    //       //controller: _controllerCheckIn,
    //       keyboardType: TextInputType.datetime,
    //       decoration: InputDecoration(
    //           labelText: 'Enter Travel Date',
    //           border: OutlineInputBorder(),
    //           icon: Icon(Icons.calendar_today)),
    //       onTap: () {
    //         FocusScope.of(context).requestFocus(new FocusNode());

    //         //CupertinoDatePicker(onDateTimeChanged: k => planModel)

    //         showDatePicker(
    //             context: context,
    //             initialDate: DateTime.now(),
    //             firstDate: DateTime.parse('1900-01-01'),
    //             lastDate: DateTime.parse('2099-01-01'));

    //         //_chooseDateIn(context, _controllerCheckIn.text, accomodation);
    //       },
    //       onSaved: (value) {
    //         planModel.travelDate = convertToDate(value);
    //       },
    //       validator: (value) {
    //         if (value.isEmpty) {
    //           return 'Please enter a check-in date';
    //         } else {
    //           return null;
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
}

// DateTime convertToDate(String input) {
//   try {
//     var d = new DateFormat.yMd().parseStrict(input);
//     return d;
//   } catch (e) {
//     return null;
//   }
// }
