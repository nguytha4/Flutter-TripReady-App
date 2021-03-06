import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class DestinationList extends StatelessWidget {
  final String planType;

  const DestinationList({Key key, this.planType}) : super(key: key);

  Stream<dynamic> buildQuery(uid) {
    if (planType == PlanTypes.upcoming) {
      return Firestore.instance
          .collection('users')
          .document(uid)
          .collection('plans')
          .where('returnDate', isGreaterThanOrEqualTo: DateTime.now())
          .snapshots();
    } else {
      return Firestore.instance
          .collection('users')
          .document(uid)
          .collection('plans')
          .where('returnDate', isLessThan: DateTime.now())
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthenticationService.currentUserId(),
      builder: (context, userIdSnapshot) {
        if (!userIdSnapshot.hasData) {
          return CircularProgressIndicator();
        }

        return StreamBuilder(
            stream: buildQuery(userIdSnapshot.data),
            builder: (context, AsyncSnapshot plansSnapshot) {
              return Container(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('destinations')
                        .snapshots(),
                    builder: (context, destinationsSnapshot) {
                      return buildListView(destinationsSnapshot, plansSnapshot);
                    }),
              );
            });
      },
    );
  }

  Widget buildListView(
      AsyncSnapshot destinationsSnapshot, AsyncSnapshot plansSnapshot) {
    if (!destinationsSnapshot.hasData || !plansSnapshot.hasData) {
      return Center(
          child: Column(children: [
        Padding(
            child: CircularProgressIndicator(), padding: EdgeInsets.all(50)),
      ]));
    }

    if (plansSnapshot.data.documents.length == 0) {
      return Center(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Text('No items. Please click the button below'),
        )
      ]));
    }

    var plans = (plansSnapshot.data.documents as List<DocumentSnapshot>)
      .map((e) => PlanModel.fromSnapshot(e))
      .toList();

    plans.sort((x, y) => x.travelDate.compareTo(y.travelDate));

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: plans.length,
      itemBuilder: (BuildContext context, int index) {
        var planModel = plans[index];

        var destinationSnapshot = destinationsSnapshot.data.documents
            .singleWhere(
                (element) => element.documentID == planModel.destinationID);

        var destination = DestinationModel.fromSnapshot(destinationSnapshot);

        return PhotoListViewTile(
          title: "${destination.city}",
          subtitle: destination.country,
          datetitle:
              '${planModel.travelDateString} - ${planModel.returnDateString}',
          imageUrl: destination.imageUrl,
          routeBuilder: () => MaterialPageRoute(
            builder: (_) => DestinationScreen(
              destination: destination,
              plan: planModel,
            ),
          ),
          onDelete: () => showDeleteDialog(context, planModel),
        );
      },
    );
  }

  Future showDeleteDialog(context, PlanModel plan) async {
  await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text("Delete this trip?"), titleTextStyle: TextStyle(color: Colors.red),
            
            actions: [
              new FlatButton(
                child: new Text("Confirm"),
                onPressed: () async {
                  await DataService.deletePlan(plan.documentID);
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
}

