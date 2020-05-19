import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipsScreen extends StatefulWidget {
  static const routeName = 'tips_screen';
  final DestinationModel destination;

  TipsScreen({this.destination});
  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  String userId;
  String category;
  String subcat;
  final formKey = GlobalKey<FormState>();   // Form key to perform validation / saving
  //final Entry entry = Entry();

  @override
  void initState() {
    super.initState();
    getUser();
  }
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: widget.destination.country + ' - Tips',
      child: 

      StreamBuilder(
        stream: Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').snapshots(),
        builder: (content, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator(),);
          } else {
            return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                final docID = snapshot.data.documents[index].documentID;
                var tipsObject = snapshot.data.documents[index];
                final tipsCategoryName = tipsObject['category'];
                final tipsSubcatNames = tipsObject['subcat'];

                List<Entry> tipsSubcats = List<Entry>();

                var i = 0;
                while (i < tipsSubcatNames.length) {
                  var tipsSubcatName = Entry(tipsSubcatNames[i]);
                  tipsSubcats.add(tipsSubcatName);
                  i++;
                }

                Entry tipsCategory = Entry(
                  tipsCategoryName,
                  tipsSubcats,
                );

                return Column(
                  children: <Widget>[
                      _buildTiles(tipsCategory, docID),
                  ],
                );
              },
            );
          } 
        },
      ),

      fab: fab(),
    );
  }

  // ====================================== Widget Functions ======================================

  Widget fab() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: () {
        confirmDialog();
      } 
    );
  }

  // ========================================= Functions ==========================================

  void confirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Theme(
            data: ThemeData(
                primaryColor: Colors.blue
              ),
            child: Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter a category:',
                ),
                onSaved: (value) {
                  category = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a category';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                if (formKey.currentState.validate()) {
                   formKey.currentState.save();

                   Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').add( {
                      'category': category,
                      'subcat' : [],
                   });

                   Navigator.of(context).pop();
                }

                
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

  void confirmDialog2(String docID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Theme(
            data: ThemeData(
                primaryColor: Colors.blue
              ),
            child: Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter a tip:',
                ),
                onSaved: (value) {
                  subcat = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a tip';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                if (formKey.currentState.validate()) {
                   formKey.currentState.save();

                  List<String> subcats = List<String>();
                  subcats.add(subcat);


                   Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID).updateData( {
                      'subcat' : FieldValue.arrayUnion(subcats),
                   });

                   Navigator.of(context).pop();
                }

                
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

  void deleteEntry() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete entry?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                List<String> subcats = List<String>();


                // Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID).updateData( {
                //   'subcat' : FieldValue.arrayRemove(subcats),
                // });
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

  // ==================================================================================================

  Widget _buildTiles(Entry root, String docID) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(root.title), 
        trailing: GestureDetector(
          onTap: () {
            confirmDialog2(docID);
          },
          child: Icon(Icons.add)),
      ); 
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: 
      // ListView.builder(
      //   itemCount: 4,
      //   itemBuilder: (content, index) {
      //     return Column(
      //       children: <Widget>[
      //         ListTile(
                
      //         ),
      //       ],
      //     );
      //   },
      // ),
      //root.children.map(_buildTilesChildren).toList(),
      [_buildTilesChildren2(root),],
      trailing: GestureDetector(
        onTap: () {
          confirmDialog2(docID);
        },
        child: Icon(Icons.add)
      ),
    );
  }

  // Widget _buildTilesChildren(Entry root) {
  //   return ListTile(title: Padding(
  //     padding: const EdgeInsets.only(left: 20.0),
  //     child: Text(root.title),
  //   ),
  //   onLongPress: () {
  //     deleteEntry();
  //   },
  //   );
  // }

  Widget _buildTilesChildren2(Entry root,) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      key: PageStorageKey('myscrollable'),
      itemCount: root.children.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(root.children[index].title),
          ),
        );
      },
    );
  }
} 