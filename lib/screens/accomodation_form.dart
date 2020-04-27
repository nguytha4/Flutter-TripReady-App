import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AccomodationForm extends StatefulWidget {
  @override
  _AccomodationFormState createState() => _AccomodationFormState();
}

class _AccomodationFormState extends State<AccomodationForm> {

  final formKey = GlobalKey<FormState>();   // Form key to perform validation / saving
  final accomodation = Accomodation();      // Accomodation object to save form values

  final TextEditingController _controllerCheckIn = new TextEditingController();
  final TextEditingController _controllerCheckOut = new TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveDateAndTime();
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
                  checkOutDateFormField(accomodation),
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

    setState(() {
      _controllerCheckIn.text = new DateFormat.yMd().format(result);
    });
  }

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

    setState(() {
      _controllerCheckOut.text = new DateFormat.yMd().format(result);
    });
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
          MaterialPageRoute(builder: (context) => WalletScreen()));
  }

  void retrieveDateAndTime() async {
    accomodation.timestamp = DateTime.now();
  }

  // ==================================== Widget functions ====================================

  Widget nameFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Enter Accomodation Name', border: OutlineInputBorder(), icon: Icon(Icons.home)
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
    );
  }

  Widget phoneFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Enter Phone Number', border: OutlineInputBorder(), icon: Icon(Icons.phone)
        ),
        onSaved: (value) {
          accomodation.phoneNum = value;
        },
      ),
    );
  }

  Widget emailFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Enter Email', border: OutlineInputBorder(), icon: Icon(Icons.email)
        ),
        onSaved: (value) {
          accomodation.email = value;
        },
      ),
    );
  }

  Widget addressFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Enter Address', border: OutlineInputBorder(), icon: Icon(Icons.location_on)
        ),
        onSaved: (value) {
          accomodation.address = value;
        },
      ),
    );
  }

  Widget confirmNumFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Enter Confirmation Number', border: OutlineInputBorder(), icon: Icon(Icons.confirmation_number)
        ),
        onSaved: (value) {
          accomodation.confirmNum = value;
        },
      ),
    );
  }

  Widget checkInDateFormField(Accomodation accomodation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controllerCheckIn,
        decoration: InputDecoration(
          labelText: 'Enter Check-in Date', border: OutlineInputBorder(), icon: Icon(Icons.calendar_today)
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _chooseDateIn(context, _controllerCheckIn.text, accomodation);
        },
        onSaved: (value) {
          accomodation.checkInDateTime = convertToDate(value);
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a check-in date';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget checkOutDateFormField(Accomodation accomodation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: TextFormField(
            controller: _controllerCheckOut,
            decoration: InputDecoration(
              labelText: 'Enter Check-out Date', border: OutlineInputBorder(), icon: Icon(Icons.calendar_today)
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _chooseDateOut(context, _controllerCheckOut.text, accomodation);
            },
            onSaved: (value) {
              accomodation.checkOutDateTime = convertToDate(value);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a check-out date';
              } else {
                return null;
              }
            },
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

            Firestore.instance.collection('accomodation').add( {
               'timestamp': accomodation.timestamp,
               'name': accomodation.name,
               'phoneNum': accomodation.phoneNum,
               'email': accomodation.email,
               'address': accomodation.address,
               'confirmNum': accomodation.confirmNum,
               'checkInDateTime': accomodation.checkInDateTime,
               'checkOutDateTime': accomodation.checkOutDateTime,
            });

            toWalletScreen(context);
         }
      },
   );
  }

  // ================================== Functions End ======================================

}