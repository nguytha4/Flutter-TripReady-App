import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = 'wallet_screen';

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Wallet Screen',
      child: StreamBuilder(
        stream: Firestore.instance.collection('passport_id').orderBy('date', descending: true).snapshots(),
        builder: (content, snapshot) {
          if (!snapshot.data.documents.isEmpty) {
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
                          onTap: () {
                            toDetailsScreen(context, passportIDName, passportImageURL);
                          },
                        ),
                      ),
                    Divider(),
                  ],
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),

      fab: fab(),
    );
  }

  // ====================================== Functions ========================================

  void toPassportIDForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PassportIDForm()));
  }

  void toAccomodationForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AccomodationForm()));
  }

  void toEventForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventForm()));
  }

  void toTransitForm(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => TransitForm()));
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

  void toDetailsScreen(BuildContext context, String name, String imageURL) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletDetailsScreen(),
        settings: RouteSettings(
          name: 'details',
          arguments: PassportID(
            name: name, imageURL: imageURL,
          ),
        ), 
    ));
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
