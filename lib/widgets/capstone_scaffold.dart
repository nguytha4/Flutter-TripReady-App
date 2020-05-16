import 'package:flutter/material.dart';

class CapstoneScaffold extends StatelessWidget {

  final String title;
  final Widget child;
  final Widget appbarChild;
  final Widget fab;
  final bool hideAppBar;
  final bool hideDrawer;

  CapstoneScaffold({Key key, this.title, this.child, this.fab, this.appbarChild, this.hideAppBar = false, this.hideDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(appbarChild),
      body: child,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20), 
        child: fab),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
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
}
