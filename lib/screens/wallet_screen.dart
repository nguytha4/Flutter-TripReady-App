import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = 'wallet_screen';
  final DestinationModel destination;
  final PlanModel plan;

  WalletScreen({this.destination, this.plan});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  String userId;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: CapstoneScaffold(
          title: widget.destination.country + ' - Wallet',
          appbarChild: TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.account_circle)),
                    Tab(icon: Icon(Icons.flight)),
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.confirmation_number)),
                  ],
                ),
          child: 
            TabBarView(
              children: <Widget>[
                
                
                // Passport ID stream
                StreamBuilder(
                  stream: Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.plan.documentID).collection('passportID').orderBy('timestamp', descending: true).snapshots(),
                  builder: (content, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator(),);
                    } else {
                      return new ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          var passportIDObject = snapshot.data.documents[index];
                          final passportIDName = passportIDObject['name'];
                          final passportImageURL = passportIDObject['imageURL'];
                          return Column(
                            children: <Widget>[
                                Ink(
                                  color: Colors.green,
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(passportIDName + '\'s passport / ID'),
                                    ),
                                    onTap: () => toPassportIDDetails(context, passportIDName, passportImageURL),
                                    onLongPress: () => deleteEntryDialog('passportID', snapshot, index),
                                  ),
                                ),
                              Divider(),
                            ],
                          );
                        },
                      );
                    } 
                  },
                ),


                // Transit stream
                StreamBuilder(
                  stream: Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.plan.documentID).collection('transit').orderBy('departDateTime', descending: false).snapshots(),
                  builder: (content, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator(),);
                    } else {
                      return new ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          var transitObject = snapshot.data.documents[index];
                          final transitName = transitObject['name'];
                          final transitStartLocation = transitObject['startLocation'];
                          final transitDestination = transitObject['destination'];
                          final transitConfirmNum = transitObject['confirmNum'];
                          final transitDepartDateTime = transitObject['departDateTime'].toDate();
                          final transitArriveDateTime = transitObject['arriveDateTime'].toDate();
                          return Column(
                            children: <Widget>[
                                Ink(
                                  color: Colors.orange,
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(transitName),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('Departs at ' + DateFormat('MMMM dd, hh:mm aa').format(transitDepartDateTime)),
                                    ),
                                    onTap: () => toTransitDetails(context, transitName, transitStartLocation, transitDestination, transitConfirmNum, transitDepartDateTime, transitArriveDateTime),
                                    onLongPress: () => deleteEntryDialog('transit', snapshot, index),
                                  ),
                                ),
                              Divider(),
                            ],
                          );
                        },
                      );
                    } 
                  },
                ),

                // Accomodation stream
                StreamBuilder(
                  stream: Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.plan.documentID).collection('accomodation').orderBy('checkInDateTime', descending: false).snapshots(),
                  builder: (content, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator(),);
                    } else {
                      return new ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          var accomodationObject = snapshot.data.documents[index];
                          final accomodationName = accomodationObject['name'];
                          final accomodationPhoneNum = accomodationObject['phoneNum'];
                          final accomodationEmail = accomodationObject['email'];
                          final accomodationAddress = accomodationObject['address'];
                          final accomodationConfirmNum = accomodationObject['confirmNum'];
                          final accomodationCheckInDateTime = accomodationObject['checkInDateTime'].toDate();
                          final accomodationCheckOutDateTime = accomodationObject['checkOutDateTime'].toDate();
                          return Column(
                            children: <Widget>[
                                Ink(
                                  color: Colors.red,
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(accomodationName),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('Check-in at ' + DateFormat('MMMM dd, hh:mm aa').format(accomodationCheckInDateTime)),
                                    ),
                                    onTap: () => toAccomodationDetails(context, accomodationName, accomodationPhoneNum, accomodationEmail, accomodationAddress, accomodationConfirmNum, accomodationCheckInDateTime, accomodationCheckOutDateTime),
                                    onLongPress: () => deleteEntryDialog('accomodation', snapshot, index),
                                  ),
                                ),
                              Divider(),
                            ],
                          );
                        },
                      );
                    } 
                  },
                ),

                // Event stream
                StreamBuilder(
                  stream: Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.plan.documentID).collection('event').orderBy('startDateTime', descending: false).snapshots(),
                  builder: (content, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator(),);
                    } else {
                      return new ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          var eventObject = snapshot.data.documents[index];
                          final eventName = eventObject['name'];
                          final eventPhoneNum = eventObject['phoneNum'];
                          final eventEmail = eventObject['email'];
                          final eventAddress = eventObject['address'];
                          final eventConfirmNum = eventObject['confirmNum'];
                          final eventCheckInDateTime = eventObject['startDateTime'].toDate();
                          return Column(
                            children: <Widget>[
                                Ink(
                                  color: Colors.blue,
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(eventName),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('Starts at ' + DateFormat('MMMM dd, hh:mm aa').format(eventCheckInDateTime)),
                                    ),
                                    onTap: () => toEventDetails(context, eventName, eventPhoneNum, eventEmail, eventAddress, eventConfirmNum, eventCheckInDateTime),
                                    onLongPress: () => deleteEntryDialog('event', snapshot, index),
                                  ),
                                ),
                              Divider(),
                            ],
                          );
                        },
                      );
                    } 
                  },
                ),
              ],
            ),
            fab: speedDialFab(),
          ),
      );
    
  }

  // ====================================== Functions ========================================

  void toPassportIDForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PassportIDForm(destination: widget.destination, plan: widget.plan)));
  }

  void toAccomodationForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AccomodationForm(destination: widget.destination, plan: widget.plan)));
  }

  void toEventForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventForm(destination: widget.destination, plan: widget.plan)));
  }

  void toTransitForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TransitForm(destination: widget.destination, plan: widget.plan)));
  }

  void toPassportIDDetails(BuildContext context, String name, String imageURL) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PassportIDDetails(),
        settings: RouteSettings(
          name: 'details',
          arguments: PassportID(
            name: name, imageURL: imageURL,
          ),
        ), 
    ));
  }

  void toAccomodationDetails(BuildContext context, String name, String phoneNum, String email, String address, String confirmNum, DateTime checkInDateTime, DateTime checkOutDateTime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccomodationDetails(),
        settings: RouteSettings(
          name: 'details',
          arguments: Accomodation(
            name: name, 
            phoneNum: phoneNum, 
            email: email, 
            address: address, 
            confirmNum: confirmNum, 
            checkInDateTime: checkInDateTime, 
            checkOutDateTime: checkOutDateTime,
          ),
        ), 
    ));
  }

  void toEventDetails(BuildContext context, String name, String phoneNum, String email, String address, String confirmNum, DateTime startDateTime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetails(),
        settings: RouteSettings(
          name: 'details',
          arguments: Event(
            name: name, 
            phoneNum: phoneNum, 
            email: email, 
            address: address, 
            confirmNum: confirmNum, 
            startDateTime: startDateTime, 
          ),
        ), 
    ));
  }

  void toTransitDetails(BuildContext context, String name, String startLocation, String destination, String confirmNum, DateTime departDateTime, DateTime arriveDateTime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransitDetails(),
        settings: RouteSettings(
          name: 'details',
          arguments: Transit(
            name: name, 
            startLocation: startLocation, 
            destination: destination, 
            confirmNum: confirmNum, 
            departDateTime: departDateTime, 
            arriveDateTime: arriveDateTime
          ),
        ), 
    ));
  } 

  void deleteEntryDialog(String collection, AsyncSnapshot snapshot, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete entry?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.plan.documentID).collection(collection).document(snapshot.data.documents[index].documentID).delete();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userId = user.uid;
      setState(() {});
  }

  // ==================================== Widget functions ====================================

  Widget speedDialFab() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // Passport / ID
        SpeedDialChild(
          child: Icon(Icons.account_circle),
          backgroundColor: Colors.green,
          label: 'Passport / ID',
          onTap: () => toPassportIDForm(context),
        ),
        // Transit
        SpeedDialChild(
          child: Icon(Icons.flight),
          backgroundColor: Colors.orange,
          label: 'Transit',
          onTap: () => toTransitForm(context),
        ),
        // Accomodation
        SpeedDialChild(
          child: Icon(Icons.home),
          backgroundColor: Colors.red,
          label: 'Accomodation',
          onTap: () => toAccomodationForm(context),
        ),
        // Event
        SpeedDialChild(
          child: Icon(Icons.confirmation_number),
          backgroundColor: Colors.blue,
          label: 'Event',
          onTap: () => toEventForm(context),
        ),
      ],
    );
  }

}
