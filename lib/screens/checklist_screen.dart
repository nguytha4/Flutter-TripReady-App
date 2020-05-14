import 'package:capstone/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:capstone/tripready.dart';

class ChecklistScreen extends StatefulWidget {
  static const routeName = 'checklist_screen';
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
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
                Firestore.instance.collection('users').document(userId).collection('checklist').document(_id).updateData({
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
                print(userId);
                setState(() {
                  _data[index]['checked'] = value;
                  Firestore.instance.collection('users').document(userId).collection('checklist').document(_id).updateData({
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
          stream: Firestore.instance.collection('users').document(userId).collection('checklist').snapshots(),
          builder: (content, snapshot) {
            print(snapshot.data.documents);
            if (snapshot.hasData && snapshot.data.documents.length != 0) {
               
               print(snapshot.data.documents.length);
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
        createDeleteDialog(context).then((val) {;
          if (val != null) {
          setState(() {
            Firestore.instance.collection('users').document(userId).collection('checklist').document(_id).delete();
            // _data.add(Entry(val));
          });
        }});
      },
              child: ExpansionTile(
                leading: Checkbox(
                value: _data['checked'] ?? false,
                onChanged: (bool value) {
                  setState(() {
                    // print(_data);
                  Firestore.instance.collection('users').document(userId).collection('checklist').document(_id).updateData({
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
                      Firestore.instance.collection('users').document(userId).collection('checklist').document(_id).updateData({
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
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
      onPressed: () {
        createAlertDialog(context).then((val) {
          if (val != null) {
          setState(() {
            Firestore.instance.collection('users').document(userId).collection('checklist').add({
                      'title': val,
                      'checked': false,
                      'date': DateTime.now(),
                      'children': []
                    });
            // _data.add(Entry(val));
          });
        }});
      },
    );
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
  // Future<String> createAlertDialog(BuildContext context) {
  //   TextEditingController myController = TextEditingController();

  //   return showDialog(context: context, builder: (context) {
  //     return AlertDialog(
  //       title: Text("Enter Category"),
  //       content: TextField(
  //         controller: myController,
  //       ),
  //       actions: [
  //         MaterialButton(
  //           elevation: 5.0,
  //           child: Text("Submit"),
  //           onPressed: () {
  //             Navigator.of(context).pop(myController.text.toString());
  //           },
  //         )
  //       ]
  //     );
  //   });
  // }
}

  




// class EntryItem extends StatefulWidget {
//   const EntryItem(this.entry);

//   final Entry entry;

//   @override
//   _EntryItemState createState() => _EntryItemState();
// }

// class _EntryItemState extends State<EntryItem> {
//   bool checkBoxState = false;

//   Widget _buildTiles(Entry root) {
//     if (root.children.isEmpty) return ListTile(title: Text(root.title));
//     return ExpansionTile(
//       key: PageStorageKey<Entry>(root),
//       title: Text(root.title),
//       children: root.children.map(_buildTiles).toList(),
//       trailing: FlatButton(child: Icon(Icons.add),
//       onPressed: () {
//         createAlertDialog(context).then((val) {
//           if (val != null) {
//             setState(() {
//               data.add(Entry(val, <Entry>[Entry('part 1')]));
//             });
//         }});
//       },
//       ),
//       leading: 
//       FlatButton(
//         child:buildCheckbox(context),
//       onPressed: () {
//         setState(() {
//           print(checkBoxState);
//           checkBoxState = !checkBoxState;
//         });
//       },
//       ),
//     );
//   }

//   Widget buildCheckbox(BuildContext context) {
//     if (checkBoxState == false) {
//       return Icon(Icons.check_box_outline_blank);
//     } else {
//       return Icon(Icons.check_box);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildTiles(widget.entry);
//   }
// }




