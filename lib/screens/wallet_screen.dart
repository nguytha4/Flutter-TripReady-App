import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = 'wallet_screen';
  final Destination destination;

  WalletScreen({this.destination});

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
                  stream: Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('passportID').orderBy('timestamp', descending: true).snapshots(),
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
                                      child: Text('Passport / ID - ' + passportIDName,),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        confirmDialog('passportID', snapshot, index);
                                      },
                                      child: Icon(Icons.more_vert)
                                    ),
                                    onTap: () {
                                      toPassportIDDetails(context, passportIDName, passportImageURL);
                                    },
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
                  stream: Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('transit').orderBy('timestamp', descending: true).snapshots(),
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
                                      child: Text('Transit - ' + transitName,),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        confirmDialog('transit', snapshot, index);
                                      },
                                      child: Icon(Icons.more_vert)
                                    ),
                                    onTap: () {
                                      toTransitDetails(context, transitName, transitStartLocation, transitDestination, transitConfirmNum, transitDepartDateTime, transitArriveDateTime);
                                    },
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
                  stream: Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('accomodation').orderBy('timestamp', descending: true).snapshots(),
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
                                      child: Text('Accomodation - ' + accomodationName,),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        confirmDialog('accomodation', snapshot, index);
                                      },
                                      child: Icon(Icons.more_vert)
                                    ),
                                    onTap: () {
                                      toAccomodationDetails(context, accomodationName, accomodationPhoneNum, accomodationEmail, accomodationAddress, accomodationConfirmNum, accomodationCheckInDateTime, accomodationCheckOutDateTime);
                                    },
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
                  stream: Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('event').orderBy('timestamp', descending: true).snapshots(),
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
                                  color: Colors.purple,
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text('Event - ' + eventName,),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        confirmDialog('event', snapshot, index);
                                      },
                                      child: Icon(Icons.more_vert)
                                    ),
                                    onTap: () {
                                      toEventDetails(context, eventName, eventPhoneNum, eventEmail, eventAddress, eventConfirmNum, eventCheckInDateTime,);
                                    },
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
            fab: fab(),
          ),
      );
    
  }

  // ====================================== Functions ========================================

  void toPassportIDForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PassportIDForm(destination: widget.destination)));
  }

  void toAccomodationForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AccomodationForm(destination: widget.destination)));
  }

  void toEventForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventForm(destination: widget.destination)));
  }

  void toTransitForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TransitForm(destination: widget.destination)));
  }
  
  void _asyncSimpleDialog(BuildContext context) async {
    final selectedValue = await showDialog<int>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select category:'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: const Text('Passport / ID'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: const Text('Accomodation'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 3);
                },
                child: const Text('Transit'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 4);
                },
                child: const Text('Event'),
              ),
            ],
          );
        }
      );

      if (selectedValue == 1) {
        toPassportIDForm(context);
      }

      if (selectedValue == 2) {
        toAccomodationForm(context);
      }

      if (selectedValue == 3) {
        toTransitForm(context);
      }

      if (selectedValue == 4) {
        toEventForm(context);
      }
  }

  // user defined function
  void confirmDialog(String collection, AsyncSnapshot snapshot, int index) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete entry?"),
          //content: new Text("Please confirm."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                Firestore.instance.collection(collection).document(snapshot.data.documents[index].documentID).delete();
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

  getUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userId = user.uid;
      setState(() {});
  }

  // ==================================== Widget functions ====================================

  Widget fab() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: () => _asyncSimpleDialog(context),
    );
  }

}
