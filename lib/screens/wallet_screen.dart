import 'package:flutter/material.dart';
import 'package:capstone/screens/passportID_form.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = 'wallet_screen';

  @override
  _WalletScreenState createState() => _WalletScreenState();
}



class _WalletScreenState extends State<WalletScreen> {

void toPassportIDForm(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PassportIDForm()));
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
    print(selectedValue);
    if (selectedValue == 1) {
      toPassportIDForm(context);
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Screen'),
        centerTitle: true,
      ),
      body: Center(child: const Text('Press the button below!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _asyncSimpleDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
