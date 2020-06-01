import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:capstone/tripready.dart';
import 'dart:developer';
import 'dart:collection';

class ChecklistScreen extends StatefulWidget  {
  static const routeName = 'checklist_screen';
  final DestinationModel destination;
  final PlanModel planModel;

  ChecklistScreen({this.destination, this.planModel});
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> with TickerProviderStateMixin{
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _counter = 0;
  String userId;
  List crowd_source;
  LinkedHashMap sortedMap;
  DocumentSnapshot doc;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getUser();
    _getCrowdSource2();
    
    // getSourcedDrawer();
  }

  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: "Checklist",
      child: buildPanels(),
      fab: fab(),
    );
  }

  // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
  }

  getUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userId = user.uid;
      setState(() {});
  }

  Widget showSourcedDrawer() {
    if (crowd_source == null ||crowd_source.length == 0 ) {
      return Column(
        children: [SizedBox(height:30), Center(child:Text("No data found."))]);
    } else {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: crowd_source.length,
      itemBuilder: (context, index) {
      var score = sortedMap[crowd_source[index]];
      return ListTile(
        title: Text(crowd_source[index]),
        trailing: Text("Score: $score")
      );
      },
    );
  } 
  }

  Widget buildChildren(List _data, var _id) {
       return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _data?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
          if (_data[index] != null) {
            return 
            Dismissible (
            
            key: Key(_data[index]['title'] + DateTime.now().millisecondsSinceEpoch.toString()),
            onDismissed: (direction) {
              setState(() {
                 _removeFromCrowdSource(_data[index]['title']);
                _data.removeAt(index);
                Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.planModel.documentID).collection('checklist').document(_id).updateData({
                    'children': _data
                  });  
              });
            },
            background: Container(color: Colors.red,),
            child: 
            ListTile(
              leading: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child:Checkbox(
              value: _data[index]['checked'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  _data[index]['checked'] = value;
                  Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.planModel.documentID).collection('checklist').document(_id).updateData({
                    'children': _data,
                  });
                });
              },
              )),
              title: Text(_data[index]['title'], style: TextStyle(fontSize: 13),),
            ));
          } else {
            return ListTile(
              title: CircularProgressIndicator(),
            );
          }
          },
       );
  }

  Widget buildPanels() {
       return StreamBuilder(
          stream: Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.planModel.documentID).collection('checklist').snapshots(),
          builder: (content, snapshot) {
            if (snapshot.hasData && snapshot.data.documents.length != 0) {
               return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
            var _data = snapshot.data.documents[index];
            var _id = snapshot.data.documents[index].documentID;
              return 
              GestureDetector(
              onLongPress: () {
        createDeleteDialog(context).then((val) {
          if (val != null) {
          setState(() {
            Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.planModel.documentID).collection('checklist').document(_id).delete();
            if (_data['children'].length > 0) {
              for (int i = 0; i < _data['children'].length; i++) {
                _removeFromCrowdSource(_data['children'][i]['title']);
              }
            }
            // _removeFromCrowdSource(_data['title']);
          });
        }});
      },
              child: ExpansionTile(
                leading: Checkbox(
                value: _data['checked'] ?? false,
                onChanged: (bool value) {
                  setState(() {
                    
                  Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.planModel.documentID).collection('checklist').document(_id).updateData({
                    'checked': value,
                  });                    
                  });
                },
                ),
                title: Text(_data['title']),
                // title: Text('title'),
                children: [buildChildren(_data['children'], _id)],
                // children: [Text('1')],
                trailing: FlatButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                  createAlertDialog(context, _id, _data).then((val) {
                    // print(val);
                    if (val != null && val != "crowd_sourced") {
                    setState(() {
                      _addToCrowdSource(val);
                      Map c = {
                        'title': val,
                        'checked': false
                      };
                      var _data2 = List.from(_data['children']);
                      _data2.add(c);
                      Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.planModel.documentID).collection('checklist').document(_id).updateData({
                      'children': _data2
                      }); 
                    });
                  } else {
                    
                    setState(() {
                      Scaffold.of(context).openDrawer();
                    });
                  }
                  
                  }
                  );
                } ,
                ),
              ));
            
            });
              }
            else {
              return ListTile( title:Text('No entries'));
            }
            });
  }

Widget fab() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: () {
        createAlertDialogFAB(context).then((val) {
          if (val != null) {
          setState(() {
            Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.planModel.documentID).collection('checklist').add({
                      'title': val,
                      'checked': false,
                      'date': DateTime.now(),
                      'children': []
                    });
          });
        }});
      },
    );
  }

  void _addToCrowdSource(String val) {
    // print(val);
    var document = Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced')
    .get().then((DocumentSnapshot) {
      
      
      var global_checklist_entry = val.toLowerCase().trim();
      if (DocumentSnapshot.data != null) {
      var num_entry = DocumentSnapshot.data[global_checklist_entry];
      if (num_entry == null) {
        Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').updateData({
                    global_checklist_entry: 1        
                            });
      } else {
        Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').updateData({
                    global_checklist_entry: num_entry + 1        
                            });
      }
    } else {
      Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').setData({
        global_checklist_entry: 1
      });
    }
    } 
    );
   
  }

  void _removeFromCrowdSource(String val) {
    var document = Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced')
    .get().then((DocumentSnapshot) {
      var global_checklist_entry = val.toLowerCase().trim();
      if (DocumentSnapshot.data != null) {
      var num_entry = DocumentSnapshot.data[global_checklist_entry];
      if (num_entry != null) {
        if (num_entry - 1 == 0) {
          Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').updateData({
                    global_checklist_entry: FieldValue.delete()     
                            });
      } else {
        
        Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').updateData({
                    global_checklist_entry: num_entry - 1        
                            });
      }
    }
      }
    }
    );
  }

  _getCrowdSource2() async {
    var document = await Firestore.instance.collection('destinations').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced')
    .get();

    doc = document;
    setState(() {
    if (doc.exists) {
    Map docData = doc.data;
    List mapKeys = doc.data.keys.toList(growable: false);
    List mapVals = doc.data.values.toList();
        
    var sortedKeys = mapKeys..sort((k1, k2) => doc.data[k1].compareTo(doc.data[k2]));

    if (sortedKeys.length < 5) {
      crowd_source = List.from(sortedKeys.reversed).sublist(0,sortedKeys.length);
    } else {
      crowd_source = List.from(sortedKeys.reversed).sublist(0,5);
    }

     sortedMap = LinkedHashMap
      .fromIterable(crowd_source, key: (k) => k, value: (k) => docData[k]);
  } else {
    crowd_source = [];
    sortedMap = Map();
  }
    });
  }
  

  Future<String> createAlertDialog(BuildContext context, var _id, var _data) {
    TextEditingController myController = TextEditingController();

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Enter Item"),
        content: TextField(
          controller: myController,
        ),
        actions: [
          Builder(
          builder: (context) {
          return Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 80, 0),
          child:MaterialButton(
            elevation: 5.0,
            child: Text("Crowd Source"),
            onPressed: () {
              Navigator.of(context).pop("crowd_sourced");
              crowdSourceDialog(context).then((val) {
                if (val != null) {
                  // print(val);
                 setState(() {
                   _addToCrowdSource(val);
                   Map c = {
                        'title': val,
                        'checked': false
                      };
                   var _data2 = List.from(_data['children']);
                   _data2.add(c);
                  //  print(_data2);
                   Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.planModel.documentID).collection('checklist').document(_id).updateData({
                      'children': _data2
                      }); 
                 });
              }
                  });
              
            },
          )); }
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Submit"),
            onPressed: () {
              // Scaffold.of(context).openDrawer();
              Navigator.of(context).pop(myController.text.toString());
            },
          )
    
        ]
      );
    });
  }
  
  Future<String> createAlertDialogFAB(BuildContext context) {
    TextEditingController myController = TextEditingController();

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Enter Category"),
        content: TextField(
          controller: myController,
        ),
        actions: [
          MaterialButton(
            elevation: 5.0,
            child: Text("Submit"),
            onPressed: () {
              // Scaffold.of(context).openDrawer();
              Navigator.of(context).pop(myController.text.toString());
            },
          )
    
        ]
      );
    });
  }

  Widget clist() {
    if(crowd_source == null || crowd_source.length == 0) {
              return Center(child:Text("No data found"));
            } else { return 
          Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: 300,
          child:
          ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: crowd_source.length,
          itemBuilder: (context, index) {
      
            var score = sortedMap[crowd_source[index]];
            return ListTile(
              title: Text(crowd_source[index]),
              trailing: Text("Score: $score"),
              leading: GestureDetector(
                child: Icon(Icons.add),
                onTap: (){
                 Navigator.of(context).pop(crowd_source[index]);
                },
              )
            );
          },
        ));
  }
  }

  Future<String> crowdSourceDialog(BuildContext context) {
    TextEditingController myController = TextEditingController();

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Crowd Sourced List:"),
        actions: [
          clist()    
        ]
      );
    });
  }
  
  Future<String> createDeleteDialog(BuildContext context) {
    TextEditingController myController = TextEditingController();

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Delete this entry?"),
        actions: [
          MaterialButton(
            elevation: 5.0,
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              var del = 'delete';
              Navigator.of(context).pop(del);
            },
          )
        ]
      );
    });
  }
}




