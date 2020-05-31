import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransitForm extends StatefulWidget {

  final DestinationModel destination;
  final PlanModel plan;

  TransitForm({this.destination, this.plan});

  @override
  _TransitFormState createState() => _TransitFormState();
}

class _TransitFormState extends State<TransitForm> {
  
  
final formKey = GlobalKey<FormState>();   // Form key to perform validation / saving
final transit = Transit();                // Transit object to save form values
String userId;

  final TextEditingController _controllerDepartDate = new TextEditingController();
  final TextEditingController _controllerDepartTime = new TextEditingController();
  final TextEditingController _controllerArriveDate = new TextEditingController();
  final TextEditingController _controllerArriveTime = new TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveDateAndTime();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Upload Transit',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  nameFormField(),
                  startLocationFormField(),
                  destinationFormField(),
                  confirmNumFormField(),
                  departDateFormField(transit),
                  departTimeFormField(transit),
                  arriveDateFormField(transit),
                  arriveTimeFormField(transit),
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

  Future _chooseDepartDate(BuildContext context, String initialDateString, Transit transit) async {
    
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(3000));

    if (result == null) return;

    var departTime = TimeOfDay.fromDateTime(result);

    if (transit.departDateTime != null)
    {
      departTime = TimeOfDay.fromDateTime(transit.departDateTime);
    }

    transit.departDateTime = new DateTime(result.year, result.month, result.day, departTime.hour, departTime.minute);

    setState(() {
      _controllerDepartDate.text = new DateFormat.yMd().format(result);
    });
  }

  // ======================================================

  Future _chooseDepartTime(BuildContext context, String initialTimeString, Transit transit) async { 

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

    if (transit.departDateTime == null) {
      final now = DateTime.now();
      transit.departDateTime = new DateTime(now.year, now.month, now.day, result.hour, result.minute);
    }

    transit.departDateTime = new DateTime(transit.departDateTime.year, transit.departDateTime.month, transit.departDateTime.day, result.hour, result.minute);

    setState(() {
      _controllerDepartTime.text = formatTimeOfDay(result);
    });
  }

  // ======================================================

    Future _chooseArriveDate(BuildContext context, String initialDateString, Transit transit) async {
    
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(3000));

    if (result == null) return;

    var arriveTime = TimeOfDay.fromDateTime(result);

    if (transit.arriveDateTime != null)
    {
      arriveTime = TimeOfDay.fromDateTime(transit.arriveDateTime);
    }

    transit.arriveDateTime = new DateTime(result.year, result.month, result.day, arriveTime.hour, arriveTime.minute);

    setState(() {
      _controllerArriveDate.text = new DateFormat.yMd().format(result);
    });
  }

  // ======================================================

  Future _chooseArriveTime(BuildContext context, String initialTimeString, Transit transit) async { 

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

    if (transit.arriveDateTime == null) {
      final now = DateTime.now();
      transit.arriveDateTime = new DateTime(now.year, now.month, now.day, result.hour, result.minute);
    }

    transit.arriveDateTime = new DateTime(transit.arriveDateTime.year, transit.arriveDateTime.month, transit.arriveDateTime.day, result.hour, result.minute);

    setState(() {
      _controllerArriveTime.text = formatTimeOfDay(result);
    });
  }

  // ======================================================

  // https://alvinalexander.com/source-code/flutter-function-convert-timeofday-tostring-formatted/

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); 
    return format.format(dt);
}

// ======================================================

  DateTime convertToDate(String input) {
    try 
    {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }    
  }

  // ======================================================

  void toWalletScreen(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => WalletScreen(destination: widget.destination)));
  }

  void retrieveDateAndTime() async {
    transit.timestamp = DateTime.now();
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
            labelText: 'Enter Transit Name', border: OutlineInputBorder(), icon: Icon(Icons.flight)
          ),
          onSaved: (value) {
            transit.name = value;
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter an transit name';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget startLocationFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Starting Location ', border: OutlineInputBorder(), icon: Icon(Icons.my_location)
          ),
          onSaved: (value) {
            transit.startLocation = value;
          },
        ),
      ),
    );
  }

  Widget destinationFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Enter Destination', border: OutlineInputBorder(), icon: Icon(Icons.location_on)
          ),
          onSaved: (value) {
            transit.destination = value;
          },
        ),
      ),
    );
  }

  Widget confirmNumFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Confirmation Number', border: OutlineInputBorder(), icon: Icon(Icons.confirmation_number)
          ),
          onSaved: (value) {
            transit.confirmNum = value;
          },
        ),
      ),
    );
  }

  Widget departDateFormField(Transit transit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerDepartDate,
          decoration: InputDecoration(
            labelText: 'Enter Departure Date', border: OutlineInputBorder(), icon: Icon(Icons.calendar_today)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseDepartDate(context, _controllerDepartDate.text, transit);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a departure date';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget departTimeFormField(Transit transit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerDepartTime,
          decoration: InputDecoration(
            labelText: 'Enter Time of Departure', border: OutlineInputBorder(), icon: Icon(Icons.access_time)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseDepartTime(context, _controllerDepartTime.text, transit);
          },
        ),
      ),
    );
  }

  Widget arriveDateFormField(Transit transit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerArriveDate,
          decoration: InputDecoration(
            labelText: 'Enter Arrival Date', border: OutlineInputBorder(), icon: Icon(Icons.calendar_today)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseArriveDate(context, _controllerArriveDate.text, transit);
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter an arrival date';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget arriveTimeFormField(Transit transit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerArriveTime,
          decoration: InputDecoration(
            labelText: 'Enter Time of Arrival', border: OutlineInputBorder(), icon: Icon(Icons.access_time)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseArriveTime(context, _controllerArriveTime.text, transit);
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

            Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.plan.documentID).collection('transit').add( {
               'timestamp': transit.timestamp,
               'name': transit.name,
               'startLocation': transit.startLocation,
               'destination': transit.destination,
               'confirmNum': transit.confirmNum,
               'departDateTime': transit.departDateTime,
               'arriveDateTime': transit.arriveDateTime,
            });

            Navigator.pop(context);
         }
      },
   );
  }

  // ================================== Functions End ======================================




}