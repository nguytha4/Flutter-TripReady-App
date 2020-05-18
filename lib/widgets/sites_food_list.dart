import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class SitesFoodList extends StatelessWidget {
  final DestinationModel destination;
  final String category;

  const SitesFoodList({Key key, this.destination, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var destinationId = destination.documentID;

    return Container(
      child: FutureBuilder(
        future: AuthenticationService.currentUserId(),
        builder: (BuildContext context, AsyncSnapshot<String> uid) {
          if (!uid.hasData) {
            return CircularProgressIndicator();
          }

          return StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(uid.data)
                  .collection('destinations')
                  .document(destination.documentID)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, favoritesSnapshot) {
                if (!favoritesSnapshot.hasData) {
                  return CircularProgressIndicator();
                }

                return StreamBuilder(
                  stream: Firestore.instance
                      .collection('destinations')
                      .document(destinationId)
                      .collection('activities')
                      .orderBy('name')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.documents.length == 0) {
                      return Center(
                          child: Column(children: [
                        Text(
                            'No favorites. Please favorite an activity to show it here.')
                      ]));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        var snapshotItem = snapshot.data.documents[index];
                        var activity = ActivityModel.fromSnapshot(snapshotItem);

                        var isFavorite = favoritesSnapshot.data.documents.any(
                            (element) =>
                                element.documentID == activity.documentID);

                        var showTile =
                            category == ActivityCategories.favorites &&
                                    isFavorite ||
                                activity.category == category;

                        return Visibility(
                          visible: showTile,
                          child: PhotoListViewTile(
                              title: activity.name,
                              subtitle: activity.type,
                              imageUrl: activity.imageUrl,
                              showFavoriteIcon: true,
                              isFavorite: isFavorite,
                              onFavorite: () async {
                                await DataService.toggleFavorite(
                                    destination.documentID,
                                    activity.documentID);
                              },
                              route: MaterialPageRoute(
                                builder: (_) => SitesFoodDetailScreen(
                                  destination: destination,
                                  activity: activity,
                                ),
                              )),
                        );
                      },
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
