import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class EventForm extends StatefulWidget {

  final DestinationModel destination;

  EventForm({this.destination});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  
  final formKey = GlobalKey<FormState>();   // Form key to perform validation / saving
  final event = Event();                    // Event object to save form values
  String userId;

  final TextEditingController _controllerCheckIn = new TextEditingController();
  final TextEditingController _controllerTimeIn = new TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveDateAndTime();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Upload Event',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  nameFormField(),
                  phoneFormField(),
                  emailFormField(),
                  addressFormField(),
                  confirmNumFormField(),
                  checkInDateFormField(event),
                  timeFormField(event),
                  saveButton(),
                ],
              ),
            )
          ),
      )
    );
  }

  // ====================================== Functions ========================================

  // DatePicker functions below adapated from:
  //    https://codingwithjoe.com/building-forms-with-flutter/

  Future _chooseDateIn(BuildContext context, String initialDateString, Event event) async {
    
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(3000));

    if (result == null) return;

    var temp = TimeOfDay.fromDateTime(result);

    if (event.startDateTime != null)
    {
      temp = TimeOfDay.fromDateTime(event.startDateTime);
    }

    event.startDateTime = new DateTime(result.year, result.month, result.day, temp.hour, temp.minute);

    setState(() {
      _controllerCheckIn.text = new DateFormat.yMd().format(result);
    });
  }

  Future _chooseTimeIn(BuildContext context, String initialTimeString, Event event) async { 

    var hour = 00;
    var minute = 00;

    if (initialTimeString != "") {

      var time = initialTimeString.split(" ")[0];
      var ampm = initialTimeString.split(" ")[1];

      hour = int.parse(time.split(":")[0]);
      minute = int.parse(time.split(":")[1]);

      if (ampm == "PM") {
        hour += 12;
      }
    }

    var result = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay(hour: hour, minute: minute)
    );

    if (result == null) return;

    if (event.startDateTime == null) {
      final now = DateTime.now();
      event.startDateTime = new DateTime(now.year, now.month, now.day, result.hour, result.minute);
    }

    event.startDateTime = new DateTime(event.startDateTime.year, event.startDateTime.month, event.startDateTime.day, result.hour, result.minute);

    setState(() {
      _controllerTimeIn.text = formatTimeOfDay(result);
    });
  }

  // https://alvinalexander.com/source-code/flutter-function-convert-timeofday-tostring-formatted/

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); 
    return format.format(dt);
}

  DateTime convertToDate(String input) {
    try 
    {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }    
  }

  void toWalletScreen(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => WalletScreen(destination: widget.destination,)));
  }

  void retrieveDateAndTime() async {
    event.timestamp = DateTime.now();
  }

  getUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userId = user.uid;
      setState(() {});
  }

  // ==================================== Widget functions ====================================

  Widget nameFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Event Name', border: OutlineInputBorder(), icon: Icon(Icons.event_note)
          ),
          onSaved: (value) {
            event.name = value;
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter an event name';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget phoneFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter Phone Number', border: OutlineInputBorder(), icon: Icon(Icons.phone)
          ),
          onSaved: (value) {
            event.phoneNum = value;
          },
        ),
      ),
    );
  }

  Widget emailFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Enter Email', border: OutlineInputBorder(), icon: Icon(Icons.email)
          ),
          onSaved: (value) {
            event.email = value;
          },
        ),
      ),
    );
  }

  Widget addressFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Address', border: OutlineInputBorder(), icon: Icon(Icons.location_on)
          ),
          onSaved: (value) {
            event.address = value;
          },
        ),
      ),
    );
  }

  Widget confirmNumFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Confirmation Number', border: OutlineInputBorder(), icon: Icon(Icons.confirmation_number)
          ),
          onSaved: (value) {
            event.confirmNum = value;
          },
        ),
      ),
    );
  }

  Widget checkInDateFormField(Event event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerCheckIn,
          decoration: InputDecoration(
            labelText: 'Enter Date of Event', border: OutlineInputBorder(), icon: Icon(Icons.calendar_today)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseDateIn(context, _controllerCheckIn.text, event);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter an event date';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget timeFormField(Event event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerTimeIn,
          decoration: InputDecoration(
            labelText: 'Enter Time of Event', border: OutlineInputBorder(), icon: Icon(Icons.access_time)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseTimeIn(context, _controllerTimeIn.text, event);
          },
        ),
      ),
    );
  }

  Widget saveButton() {
    return RaisedButton(
      color: Colors.blue,
      textColor: Colors.white,
      child: Text('Save'),
      onPressed: () {
        if (formKey.currentState.validate()) {
            formKey.currentState.save();

            Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('event').add( {
               'timestamp': event.timestamp,
               'name': event.name,
               'phoneNum': event.phoneNum,
               'email': event.email,
               'address': event.address,
               'confirmNum': event.confirmNum,
               'startDateTime': event.startDateTime,
            });

            toWalletScreen(context);
         }
      },
   );
  }

  // ================================== Functions End ======================================
}