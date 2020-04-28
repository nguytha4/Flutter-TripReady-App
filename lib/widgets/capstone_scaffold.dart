import 'package:flutter/material.dart';

class CapstoneScaffold extends StatelessWidget {

  final String title;
  final Widget child;
  final Widget fab;
  final bool hideAppBar;

  CapstoneScaffold({Key key, this.title, this.child, this.fab, this.hideAppBar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: child,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20), 
        child: fab),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget buildAppBar()
  {
    if (hideAppBar)
      return null;

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
}
