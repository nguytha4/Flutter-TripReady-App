import 'package:capstone/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:capstone/tripready.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:developer';
import 'dart:collection';

class ChecklistScreen extends StatefulWidget  {
  static const routeName = 'checklist_screen';
  final Destination destination;

  ChecklistScreen({this.destination});
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> with TickerProviderStateMixin{
  var _counter = 0;
  String userId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: "Checklist",
      hideAppBar: false,
      hideDrawer: false,
      fab: fab(),
      child: buildPanels()
    );
  }

  getUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userId = user.uid;
      setState(() {});
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
                _data.removeAt(index);
                Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').document(_id).updateData({
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
                  Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').document(_id).updateData({
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
          stream: Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').snapshots(),
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
            Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').document(_id).delete();
            _removeFromCrowdSource(_data['title']);
          });
        }});
      },
              child: ExpansionTile(
                leading: Checkbox(
                value: _data['checked'] ?? false,
                onChanged: (bool value) {
                  setState(() {
                    
                  Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').document(_id).updateData({
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
                  createAlertDialog(context).then((val) {
                    if (val != null) {
                    setState(() {
                      Map c = {
                        'title': val,
                        'checked': false
                      };
                      var _data2 = List.from(_data['children']);
                      _data2.add(c);
                      Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').document(_id).updateData({
                      'children': _data2
                      }); 
                    });
                  }}
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

 return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Color(0xFF2196F3),
          visible: true,
          curve: Curves.bounceIn,
          children: [
                // FAB 1
                SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Color(0xFF2196F3),
                onTap: () {    
                  
                  createAlertDialog(context).then((val) {
                  if (val != null) {
                  setState(() {
                    log(val);
                    _addToCrowdSource(val);
                    Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').add({
                              'title': val,
                              'checked': false,
                              'date': DateTime.now(),
                              'children': []
                            });          
                  });
                }});
                 },
                label: 'Add Entry',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFF2196F3)),
                // FAB 2
                SpeedDialChild(
                child: Icon(Icons.people),
                backgroundColor: Color(0xFF2196F3),
                onTap: () {
                   setState(() {
                     List user_checklist = [];
                     var user_document=Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').getDocuments().then((QuerySnapshot snapshot) {
                      snapshot.documents.forEach((element) {print('${element.data['title']}');
                      user_checklist.add(element.data['title'].toLowerCase().trim());
                      });
                      _getCrowdSource(user_checklist);
                    });
                      
                   });
                },
                label: 'Crowd Source',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Color(0xFF2196F3))
          ],
        );
  }

  void _addToCrowdSource(String val) {
    var document = Firestore.instance.collection('destination').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced')
    .get().then((DocumentSnapshot) {
      var global_checklist_entry = val.toLowerCase().trim();
      var num_entry = DocumentSnapshot.data[global_checklist_entry];
      if (num_entry == null) {
        Firestore.instance.collection('destination').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').updateData({
                    global_checklist_entry: 1        
                            });
      } else {
        Firestore.instance.collection('destination').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').updateData({
                    global_checklist_entry: num_entry + 1        
                            });
      }
    }
    );
   
  }

  void _removeFromCrowdSource(String val) {
    var document = Firestore.instance.collection('destination').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced')
    .get().then((DocumentSnapshot) {
      var global_checklist_entry = val.toLowerCase().trim();
      var num_entry = DocumentSnapshot.data[global_checklist_entry];
      log('name: $global_checklist_entry\n num_entry: $num_entry');
      if (num_entry != null) {
        if (num_entry - 1 == 0) {
          Firestore.instance.collection('destination').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').updateData({
                    global_checklist_entry: FieldValue.delete()     
                            });
      } else {
        
        Firestore.instance.collection('destination').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced').updateData({
                    global_checklist_entry: num_entry - 1        
                            });
      }
    } 
    }
    );
  }

  void _getCrowdSource(List user_checklist) {
    var document = Firestore.instance.collection('destination').document(this.widget.destination.documentID).collection('checklist_sourced').document('checklist_sourced')
    .get().then((DocumentSnapshot) {
      
      List crowd_source;
      
      Map docData = DocumentSnapshot.data;
      List mapKeys = DocumentSnapshot.data.keys.toList(growable: false);
      List mapVals = DocumentSnapshot.data.values.toList();
      // print(docData);
      var sortedKeys = DocumentSnapshot.data.keys.toList(growable: false)..sort((k1, k2) => DocumentSnapshot.data[k1].compareTo(DocumentSnapshot.data[k2]));
      if (sortedKeys.length < 5) {
        crowd_source = List.from(sortedKeys.reversed).sublist(0,sortedKeys.length);
      } else {
        crowd_source = List.from(sortedKeys.reversed).sublist(0,5);
      }

      for (var item in crowd_source) {
        if (user_checklist.contains(item) == false) {
          Firestore.instance.collection('users').document(userId).collection('destination').document(this.widget.destination.documentID).collection('checklist').add({
                                'title': item,
                                'checked': false,
                                'date': DateTime.now(),
                                'children': []
                              }); 
        }
      }
    });
  }

  Future<String> createAlertDialog(BuildContext context) {
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
              Navigator.of(context).pop(myController.text.toString());
            },
          )
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




