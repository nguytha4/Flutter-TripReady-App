import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipsScreen extends StatefulWidget {
  static const routeName = 'tips_screen';
  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'Tips Screen',
      child: 

      StreamBuilder(
        stream: Firestore.instance.collection('tips').snapshots(),
        builder: (content, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator(),);
          } else {
            return new ListView.builder(
              itemCount: snapshot.data.documents.length,   // 3
              itemBuilder: (context, index) {
                var tipsObject = snapshot.data.documents[index];
                final tipsCategoryName = tipsObject['name'];
                final tipsSubcatNames = tipsObject['subcat'];

                // print(tipsSubcatNames);
                // print(tipsSubcatNames[0]);
                // print(tipsSubcatNames[1]);
                // var entryTest = Entry(tipsSubcatNames[0]);
                // print(entryTest.title);

                List<Entry> tipsSubcats = List<Entry>();
                // tipsSubcats.add(entryTest);

                // print(tipsSubcats);

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

                    // Build out an entry
                    //    string
                    //    List<Entry>

                      //Placeholder(),
                      EntryItem(tipsCategory),



                      // Ink(
                      //   color: Colors.green,
                      //   child: ListTile(
                      //     title: Padding(
                      //       padding: const EdgeInsets.only(left: 10),
                      //       child: Text('Tips - ' + tipsCategory,),
                      //     ),
                      //     onTap: () {
                      //       //toPassportIDDetails(context, passportIDName, passportImageURL);
                      //     },
                      //   ),
                      // ),


                  ],
                );
              },
            );
          } 
        },
      ),
      
      // ListView.builder(
      //     itemBuilder: (BuildContext context, int index) =>
      //         EntryItem(data[index]),
      //     itemCount: data.length,
      //   ),

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

  // user defined function
  void confirmDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Enter a category:"),
          content: TextFormField(
          decoration: InputDecoration(
            labelText: 'Enter a category:',
          ),
          onSaved: (value) {
            //transit.confirmNum = value;
          },
        ),
          //new Text("Please confirm."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
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

  // ==================================================================================================

} 

// ==================================================================================================


// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}


// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}


// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'Chapter A',
    <Entry>[
      Entry(
        'Section A0',
        <Entry>[
          Entry('Item A0.1'),
          Entry('Item A0.2'),
          Entry('Item A0.3'),
        ],
      ),
      Entry('Section A1'),
      Entry('Section A2'),
    ],
  ),
  Entry(
    'Chapter B',
    <Entry>[
      Entry('Section B0'),
      Entry('Section B1'),
    ],
  ),
  Entry(
    'Chapter C',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry(
        'Section C2',
        <Entry>[
          Entry('Item C2.0'),
          Entry('Item C2.1'),
          Entry('Item C2.2'),
          Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];