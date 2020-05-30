import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AccomodationForm extends StatefulWidget {

  final DestinationModel destination;
  final PlanModel plan;

  AccomodationForm({this.destination, this.plan});

  @override
  _AccomodationFormState createState() => _AccomodationFormState();
}

class _AccomodationFormState extends State<AccomodationForm> {

  final formKey = GlobalKey<FormState>();   // Form key to perform validation / saving
  final accomodation = Accomodation();      // Accomodation object to save form values

  final TextEditingController _controllerCheckInDate = new TextEditingController();
  final TextEditingController _controllerCheckOutDate = new TextEditingController();
  final TextEditingController _controllerCheckInTime = new TextEditingController();
  final TextEditingController _controllerCheckOutTime = new TextEditingController();

  String userId;

  @override
  void initState() {
    super.initState();
    retrieveDateAndTime();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Upload Accomodation',
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
                  checkInDateFormField(accomodation),
                  checkInTimeFormField(accomodation),
                  checkOutDateFormField(accomodation),
                  checkOutTimeFormField(accomodation),
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

  Future _chooseDateIn(BuildContext context, String initialDateString, Accomodation accomodation) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(3000));

    if (result == null) return;

    var checkInTime = TimeOfDay.fromDateTime(result);

    if (accomodation.checkInDateTime != null)
    {
      checkInTime = TimeOfDay.fromDateTime(accomodation.checkInDateTime);
    }

    accomodation.checkInDateTime = new DateTime(result.year, result.month, result.day, checkInTime.hour, checkInTime.minute);

    setState(() {
      _controllerCheckInDate.text = new DateFormat.yMd().format(result);
    });
  }

  // ========================================================================================================

  Future _chooseDateOut(BuildContext context, String initialDateString, Accomodation accomodation) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime(3000));

    if (result == null) return;

    var checkOutTime = TimeOfDay.fromDateTime(result);

    if (accomodation.checkOutDateTime != null)
    {
      checkOutTime = TimeOfDay.fromDateTime(accomodation.checkOutDateTime);
    }

    accomodation.checkOutDateTime = new DateTime(result.year, result.month, result.day, checkOutTime.hour, checkOutTime.minute);

    setState(() {
      _controllerCheckOutDate.text = new DateFormat.yMd().format(result);
    });
  }

  // ========================================================================================================

  Future _chooseTimeIn(BuildContext context, String initialTimeString, Accomodation accomodation) async { 

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

    if (accomodation.checkInDateTime == null) {
      final now = DateTime.now();
      accomodation.checkInDateTime = new DateTime(now.year, now.month, now.day, result.hour, result.minute);
    }

    accomodation.checkInDateTime = new DateTime(accomodation.checkInDateTime.year, accomodation.checkInDateTime.month, accomodation.checkInDateTime.day, result.hour, result.minute);

    setState(() {
      _controllerCheckInTime.text = formatTimeOfDay(result);
    });
  }

  // ========================================================================================================

  Future _chooseTimeOut(BuildContext context, String initialTimeString, Accomodation accomodation) async { 

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

    if (accomodation.checkOutDateTime == null) {
      final now = DateTime.now();
      accomodation.checkOutDateTime = new DateTime(now.year, now.month, now.day, result.hour, result.minute);
    }

    accomodation.checkOutDateTime = new DateTime(accomodation.checkOutDateTime.year, accomodation.checkOutDateTime.month, accomodation.checkOutDateTime.day, result.hour, result.minute);

    setState(() {
      _controllerCheckOutTime.text = formatTimeOfDay(result);
    });
  }

  // ========================================================================================================

  DateTime convertToDate(String input) {
    try 
    {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }    
  }

  // ========================================================================================================

  // https://alvinalexander.com/source-code/flutter-function-convert-timeofday-tostring-formatted/
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); 
    return format.format(dt);
}

  void toWalletScreen(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => WalletScreen(destination: widget.destination,)));
  }

  void retrieveDateAndTime() async {
    accomodation.timestamp = DateTime.now();
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
            labelText: 'Enter Accomodation Name', 
            border: OutlineInputBorder(), icon: Icon(Icons.home)
          ),
          onSaved: (value) {
            accomodation.name = value;
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a name for the accomodation';
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
            labelText: 'Enter Phone Number', 
            border: OutlineInputBorder(), icon: Icon(Icons.phone)
          ),
          onSaved: (value) {
            accomodation.phoneNum = value;
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
            labelText: 'Enter Email', 
            border: OutlineInputBorder(), icon: Icon(Icons.email)
          ),
          onSaved: (value) {
            accomodation.email = value;
          },
        ),
      ),
    );
  }

  Widget addressFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter Address', 
            border: OutlineInputBorder(), icon: Icon(Icons.location_on)
          ),
          onSaved: (value) {
            accomodation.address = value;
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
            labelText: 'Enter Confirmation Number', 
            border: OutlineInputBorder(), icon: Icon(Icons.confirmation_number)
          ),
          onSaved: (value) {
            accomodation.confirmNum = value;
          },
        ),
      ),
    );
  }

  Widget checkInDateFormField(Accomodation accomodation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerCheckInDate,
          decoration: InputDecoration(
            labelText: 'Enter Check-in Date', 
            border: OutlineInputBorder(), icon: Icon(Icons.calendar_today)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseDateIn(context, _controllerCheckInDate.text, accomodation);
          },
          // onSaved: (value) {
          //   accomodation.checkInDateTime = convertToDate(value);
          // },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter a check-in date';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget checkInTimeFormField(Accomodation accomodation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerCheckInTime,
          decoration: InputDecoration(
            labelText: 'Enter Check-in Time', border: OutlineInputBorder(), icon: Icon(Icons.access_time)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseTimeIn(context, _controllerCheckInTime.text, accomodation);
          },
        ),
      ),
    );
  }

  Widget checkOutDateFormField(Accomodation accomodation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
              controller: _controllerCheckOutDate,
              decoration: InputDecoration(
                labelText: 'Enter Check-out Date', 
                border: OutlineInputBorder(), icon: Icon(Icons.calendar_today)
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _chooseDateOut(context, _controllerCheckOutDate.text, accomodation);
              },
              // onSaved: (value) {
              //   accomodation.checkOutDateTime = convertToDate(value);
              // },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a check-out date';
                } else {
                  return null;
                }
              },
            ),
      ),
    );
  }

  Widget checkOutTimeFormField(Accomodation accomodation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.blue
        ),
        child: TextFormField(
          controller: _controllerCheckOutTime,
          decoration: InputDecoration(
            labelText: 'Enter Check-out Time', border: OutlineInputBorder(), icon: Icon(Icons.access_time)
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _chooseTimeOut(context, _controllerCheckOutTime.text, accomodation);
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

            Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.plan.documentID).collection('accomodation').add( {
               'timestamp': accomodation.timestamp,
               'name': accomodation.name,
               'phoneNum': accomodation.phoneNum,
               'email': accomodation.email,
               'address': accomodation.address,
               'confirmNum': accomodation.confirmNum,
               'checkInDateTime': accomodation.checkInDateTime,
               'checkOutDateTime': accomodation.checkOutDateTime,
            });

            Navigator.pop(context);
         }
      },
   );
  }

  // ================================== Functions End ======================================

}