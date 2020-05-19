import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class CapstoneScaffold extends StatelessWidget {

  final String title;
  final Widget child;
  final Widget appbarChild;
  final Widget fab;
  final bool hideAppBar;
  final bool hideDrawer;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CapstoneScaffold({Key key, this.title, this.child, this.appbarChild, this.fab, this.hideAppBar = false, this.hideDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideDrawer != true) {
    return Scaffold(
      appBar: buildAppBar(appbarChild),
      body: child,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20), 
        child: fab),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 120,
              child: DrawerHeader(child: Text('Settings') )),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
              child:RaisedButton(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)
                ),
              child: const Text('Sign out'),
              textColor: Colors.white,
              onPressed: () async {
                Navigator.of(context).pop();  // hides drawer after clicking 'sign out'
                _signOut();
                final String uid = 'randomString';
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(MainScreen.routeName, arguments: uid);
              },
            )),
          ],)
      ),
    );
    } else {
      return Scaffold(
      appBar: buildAppBar(appbarChild),
      body: child,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20), 
        child: fab),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
    }
  }

  Widget buildAppBar(Widget appbarChild)
  {
    if (hideAppBar)
      return null;

    if (hideDrawer)
      return AppBar(
          title: Text(title),
          centerTitle: true,
      );

    return AppBar(
          title: Text(title),
          actions: [
              Builder(builder: (context) {
                return IconButton (
                icon: Icon(Icons.dehaze),
                onPressed: () => Scaffold.of(context).openEndDrawer()
                );
              }),
          ],
          bottom: appbarChild,
          centerTitle: true,
      );
  }

  // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
  }
}
