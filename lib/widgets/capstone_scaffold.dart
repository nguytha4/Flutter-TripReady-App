import 'package:flutter/material.dart';

class CapstoneScaffold extends StatelessWidget {

  final String title;
  final Widget child;
  final Widget fab;

  CapstoneScaffold({Key key, this.title, this.child, this.fab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          // actions: [
          //     Builder(builder: (context) {
          //       return IconButton (
          //       icon: Icon(Icons.settings),
          //       onPressed: () => Scaffold.of(context).openEndDrawer()
          //       );
          //     })
          //   ,
          // ],
          centerTitle: true,
      ),
      body: child,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20), 
        child: fab),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
