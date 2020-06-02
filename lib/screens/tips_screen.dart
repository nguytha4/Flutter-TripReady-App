import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';

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

  List crowd_source;
  LinkedHashMap sortedMap;
  DocumentSnapshot doc;

  @override
  void initState() {
    super.initState();
    getUser();
    getCrowdSourceList();
  }
  Widget build(BuildContext context) {

    return CapstoneScaffold(
      title: widget.destination.city + ' - Tips',
      child: 

      // Main Tips screen that shows categories and tips under each category
      StreamBuilder(
        stream: Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').orderBy('category', descending: false).snapshots(),
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
                      buildCategoryTiles(tipsCategory, docID),
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
  void addTipDialog(Entry root, String docID) {
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
              child: Text('Popular Tips'),
              onPressed: () {
                Navigator.of(context).pop();
                crowdSourceDialog(context, root, docID);
              }, 
              ),
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                if (formKey.currentState.validate()) {
                   formKey.currentState.save();

                  List<String> tipsList = List<String>();
                  tipsList.add(tip);

                  // Create a list of strings representing the current tips under the category
                  List<String> existingTipsList = List<String>();
                  for (var x in root.children) { existingTipsList.add(x.title); }
                  
                  // If the tip being added is already in the list
                  if(existingTipsList.contains(tip) == false)
                    // Add to crowdsource
                    addToCrowdSource(tip);

                  // Add the tip to the Tips collection under the user's destination
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
  void deleteCategory(Entry root, String docID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        // In case user deletes category, prepare a list to reference to pass into the removeFromCrowdSource function
        List<String> categoryTipList = List<String>();
        Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID)
          .get().then( (onValue) {
            for(var x in onValue['tips']) {
              categoryTipList.add(x);
            }
          });

        return AlertDialog(
          title: new Text("Delete entry?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {

                // Remove all categories from crowd source
                for (var x in categoryTipList) {
                  removeFromCrowdSource(x);
                }

                // Delete entire document which represents category
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

  // Get the user id to use for Firestore database operations
  getUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userId = user.uid;
      setState(() {});
  }

  // Get a map of the crowdsource items based on destination of the current trip
  getCrowdSourceList() async {
    doc = await Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('tips_sourced').document('tips_sourced').get();

    setState(() {
      if (doc.exists) {
        
        Map docData = doc.data;
        List mapKeys = doc.data.keys.toList(growable: false);
        List mapVals = doc.data.values.toList();
        
        var sortedKeys = mapKeys..sort((k1, k2) => doc.data[k1].compareTo(doc.data[k2]));

        if ( sortedKeys.length < 5) 
          crowd_source = List.from(sortedKeys.reversed).sublist(0,sortedKeys.length);
        else 
          crowd_source = List.from(sortedKeys.reversed).sublist(0,5);

        sortedMap = LinkedHashMap.fromIterable(crowd_source, key: (k) => k, value: (k) => docData[k]);
      } 
      else {
        crowd_source = [];
        sortedMap = Map();
      }
    });
  }

  // Take the value that the user entered and add it to the Destination's crowdsource list
  void addToCrowdSource(String val) {
        
    var document = Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('tips_sourced').document('tips_sourced')
    .get().then((DocumentSnapshot) {
      
      var global_checklist_entry = val.toLowerCase().trim();

        if (DocumentSnapshot.data != null) {

          var num_entry = DocumentSnapshot.data[global_checklist_entry];

          if (num_entry == null) {
            Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('tips_sourced').document('tips_sourced').updateData({
                        global_checklist_entry: 1        
                                });
          } else {
            Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('tips_sourced').document('tips_sourced').updateData({
                        global_checklist_entry: num_entry + 1        
                                });
            }
        } 

        else {
          Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('tips_sourced').document('tips_sourced').setData({
            global_checklist_entry: 1
            });
        }
    });
  }

  // Take the value that user is opting to remove and decrease the count appropriately in the crowdsource database
  void removeFromCrowdSource(String val) {

    var document = Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('tips_sourced').document('tips_sourced')
    .get().then((DocumentSnapshot) {

      var global_checklist_entry = val.toLowerCase().trim();

      if (DocumentSnapshot.data != null) {

        var num_entry = DocumentSnapshot.data[global_checklist_entry];
        
        if (num_entry != null) {
          if (num_entry - 1 == 0) {
            Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('tips_sourced').document('tips_sourced').updateData({
                    global_checklist_entry: FieldValue.delete()     
                            });
          } 
          else {
            Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('tips_sourced').document('tips_sourced').updateData({
                    global_checklist_entry: num_entry - 1        
                            });
          }
        }
      }
    });
  }

  // ==================================== Widget functions ====================================

  // Build tiles that represent categories
  Widget buildCategoryTiles(Entry root, String docID) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(root.title), 
        trailing: GestureDetector(
          onTap: () => addTipDialog(root, docID),
          child: Icon(Icons.add),
        ),
        onLongPress: () => deleteCategory(root, docID),
      ); 
    } return GestureDetector(
        onLongPress: () => deleteCategory(root, docID),
        child: ExpansionTile(
        key: PageStorageKey<Entry>(root),
        title: Text(root.title),
        children: [buildTipsTiles(root, docID),],
        trailing: GestureDetector(
            onTap: () => addTipDialog(root, docID),
            child: Icon(Icons.add)
          ),
        ),
    );
  }

  // Build the tiles that represent the tips in each category
  Widget buildTipsTiles(Entry root, String docID) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      key: PageStorageKey('myscrollable'),
      itemCount: root.children.length,
      itemBuilder: (context, index) {
        return Dismissible(
            key: Key(UniqueKey().toString()),
            onDismissed: (direction) {

              List<String> tipsList = List<String>();
                tipsList.add(root.children[index].title);

                removeFromCrowdSource(root.children[index].title);

                Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID).updateData( {
                  'tips' : FieldValue.arrayRemove(tipsList),
                });
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(root.children[index].title),
              ),
            ),
        );

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

  // Dialog that appears when user selects the crowd source button when adding a tip
  Future<String> crowdSourceDialog(BuildContext context, Entry root, String docID) {
    
    TextEditingController myController = TextEditingController();

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Crowd Sourced List:"),
        actions: [
          clist(root, docID),
          new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                addTipDialog(root, docID);
              },
            ),   
        ]
      );
    });
  }

  // Get and display crowd source list with option for user to add fro mit
  Widget clist(Entry root, String docID) {
    if(crowd_source == null || crowd_source.length == 0) {
      return Center(child:Text("No data found"));
    } 

    else { 
      final pHeight = MediaQuery.of(context).size.height;
      final pWidth = MediaQuery.of(context).size.width;
      bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

      // Crowd source dialog box fitted for portrait view
      if(isPortrait) {
        return Container(
          height: pHeight / 2,
          width: pWidth * .75,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: crowd_source.length,
            itemBuilder: (context, index) {
              var score = sortedMap[crowd_source[index]];
              return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ListTile(
                      title: Text(crowd_source[index]),
                      trailing: Text("Score: $score"),
                      leading: GestureDetector(
                        child: Icon(Icons.add),
                        onTap: () {
                         Navigator.of(context).pop(crowd_source[index]);

                         List<String> tipsList = List<String>();
                         tipsList.add(crowd_source[index]);

                         List<String> existingTipsList = List<String>();
                         for (var x in root.children) { existingTipsList.add(x.title); }
                  
                         // If the tip being added is already in the list
                         if(existingTipsList.contains(crowd_source[index]) == false)
                            // Add to crowdsource
                            addToCrowdSource(crowd_source[index]);

                          // Add the tip to the Tips collection under the user's destination
                          Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID).updateData( {
                              'tips' : FieldValue.arrayUnion(tipsList),
                           });
                        },
                      )
                    ),
                  ],
                ),
              );
            },
          )
        );
      }

    // Crowd source dialog box fitted for landscape view
    else {
      return Container(
        height: pHeight / 2,
        width: pWidth * .75,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: crowd_source.length,
          itemBuilder: (context, index) {
            var score = sortedMap[crowd_source[index]];
            return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    title: Text(crowd_source[index]),
                    trailing: Text("Score: $score"),
                    leading: GestureDetector(
                      child: Icon(Icons.add),
                      onTap: () {
                       Navigator.of(context).pop(crowd_source[index]);

                       List<String> tipsList = List<String>();
                       tipsList.add(crowd_source[index]);

                       List<String> existingTipsList = List<String>();
                         for (var x in root.children) { existingTipsList.add(x.title); }
                  
                         // If the tip being added is already in the list
                         if(existingTipsList.contains(crowd_source[index]) == false)
                            // Add to crowdsource
                            addToCrowdSource(crowd_source[index]);

                        // Add the tip to the Tips collection under the user's destination
                        Firestore.instance.collection('users').document(userId).collection('destinations').document(this.widget.destination.documentID).collection('tips').document(docID).updateData( {
                            'tips' : FieldValue.arrayUnion(tipsList),
                         });
                      },
                    )
                  ),
                ],
              ),
            );
          },
        )
      );
    }

    }
  }

} 