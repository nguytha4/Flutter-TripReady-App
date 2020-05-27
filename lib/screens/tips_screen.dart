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
  String tip;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUser();
  }
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: widget.destination.city + ' - Tips',
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
                final tipsNames = tipsObject['tips'];

                List<Entry> tipsList = List<Entry>();

                var i = 0;
                while (i < tipsNames.length) {
                  var tipName = Entry(tipsNames[i]);
                  tipsList.add(tipName);
                  i++;
                }

                Entry tipsCategory = Entry(
                  tipsCategoryName,
                  tipsList,
                );

                return Column(
                  children: <Widget>[
                      _buildCategoryTiles(tipsCategory, docID),
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

  // ========================================= Functions ==========================================

  // Dialog that appears when user adds a category
  void addCategoryDialog() {
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
                      'tips' : [],
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

  // Dialog that appears when user adds a tip under a category
  void addTipDialog(String docID) {
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
                  tip = value;
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

                  List<String> tipsList = List<String>();
                  tipsList.add(tip);

                   Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID).updateData( {
                      'tips' : FieldValue.arrayUnion(tipsList),
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

  // Dialog that appears when user tries to delete a category
  void deleteCategory(String docID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete entry?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {                

                Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID).delete();
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

  // Dialog that appears when user tries to delete a tip
  void deleteTip(String docID, String tipName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete entry?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {      

                List<String> tipsList = List<String>();
                tipsList.add(tipName);

                Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID).updateData( {
                  'tips' : FieldValue.arrayRemove(tipsList),
                });
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

  // Build tiles that represent categories
  Widget _buildCategoryTiles(Entry root, String docID) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(root.title), 
        trailing: GestureDetector(
          onTap: () => addTipDialog(docID),
          child: Icon(Icons.add),
        ),
        onLongPress: () => deleteCategory(docID),
      ); 
    } return GestureDetector(
        onLongPress: () => deleteCategory(docID),
        child: ExpansionTile(
        key: PageStorageKey<Entry>(root),
        title: Text(root.title),
        children: [_buildTipsTiles(root, docID),],
        trailing: GestureDetector(
            onTap: () => addTipDialog(docID),
            child: Icon(Icons.add)
          ),
        ),
    );
    
    // Dismissible(
    //   key: Key(UniqueKey().toString()),
    //   onDismissed: (direction) {
    //     setState( () => deleteCategory(docID));
    //   },
    //   background: Container(color: Colors.red),
    //   child: ExpansionTile(
    //   key: PageStorageKey<Entry>(root),
    //   title: Text(root.title),
    //   children: [_buildTipsTiles(root, docID),],
    //   trailing: GestureDetector(
    //       onTap: () {
    //         addTipDialog(docID);
    //       },
    //       child: Icon(Icons.add)
    //     ),
    //   ),
    // );
  }

  // Build the tiles that represent the tips in each category
  Widget _buildTipsTiles(Entry root, String docID) {
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
              onLongPress: () => deleteTip(docID, root.children[index].title),
            );
        
        // Dismissible(
        //     key: Key(UniqueKey().toString()),
        //     onDismissed: (direction) {
        //       setState( () => deleteTip(docID, root.children[index].title));
        //     },
        //     background: Container(color: Colors.red),
        //     child: ListTile(
        //       title: Padding(
        //         padding: const EdgeInsets.only(left: 20.0),
        //         child: Text(root.children[index].title),
        //       ),
        //     ),
        // );

      },
    );
  }

    Widget fab() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: () => addCategoryDialog()
    );
  }

} 