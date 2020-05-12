import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CapstoneScaffold extends StatelessWidget {

  final String title;
  final Widget child;
  final Widget fab;
  final bool hideAppBar;
  final bool hideDrawer;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CapstoneScaffold({Key key, this.title, this.child, this.fab, this.hideAppBar = false, this.hideDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
            FlatButton(
              child: const Text('Sign out'),
              textColor: Colors.blue,
              onPressed: () async {
                final FirebaseUser user = await _auth.currentUser();
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                _signOut();

                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            )
          ],)
      ),
    );
  }

  Widget buildAppBar()
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
          
          centerTitle: true,
      );
  }

    // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
  }
}
