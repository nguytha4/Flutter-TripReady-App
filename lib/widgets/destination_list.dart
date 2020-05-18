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
          .where('travelDate', isGreaterThanOrEqualTo: DateTime.now())
          .orderBy('travelDate')
          .snapshots();
    } else {
      return Firestore.instance
          .collection('users')
          .document(uid)
          .collection('plans')
          .where('travelDate', isLessThan: DateTime.now())
          .orderBy('travelDate')
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
            builder: (context, plansSnapshot) {
              return Container(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('destination')
                        .orderBy('country')
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
    if (!destinationsSnapshot.hasData ||
        destinationsSnapshot.data.documents.length <= 0) {
      return Center(
          child: Column(children: [
        Padding(
            child: CircularProgressIndicator(), padding: EdgeInsets.all(50)),
        Text('No items. Please click the button below')
      ]));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: plansSnapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {

        var planModel = PlanModel.fromSnapshot(plansSnapshot.data.documents[index]);

        var destinationSnapshot = destinationsSnapshot
          .data
          .documents
          .singleWhere((element) => element.documentID == planModel.destinationID);

        var destination = DestinationModel.fromSnapshot(destinationSnapshot);

        return PhotoListViewTile(
          title: "${destination.city}",
          subtitle: destination.country,
          imageUrl: destination.imageUrl,
          route: MaterialPageRoute(
            builder: (_) => DestinationScreen(
              destination: destination,
            ),
          ),
        );
      },
    );
  }
}
