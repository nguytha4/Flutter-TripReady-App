import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class SitesFoodList extends StatelessWidget {
  final DestinationModel destination;
  final String category;
  final String searchText;

  const SitesFoodList({Key key, this.destination, this.category, this.searchText})
      : super(key: key);


  List<ActivityModel> buildActivityList(List<DocumentSnapshot> allActivities, 
    List<DocumentSnapshot> favoriteActivities,
    String category,
    String searchText)
  {
    List<ActivityModel> activities = List<ActivityModel>();

    for (var snapshotItem in allActivities)
    {
        var activity = ActivityModel.fromSnapshot(snapshotItem);

        var isFavorite = favoriteActivities.any(
            (element) =>
                element.documentID == activity.documentID);

        var showTile =
            category == ActivityCategories.favorites &&
                    isFavorite ||
                activity.category == category;

        // filter the results
        if (searchText != null && searchText.isNotEmpty) {
          showTile = showTile && activity.name.toLowerCase().contains(searchText.toLowerCase());
        }

        if (showTile) {
          activities.add(activity);
        }
    }

    return activities;
  }


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

                    var activities = buildActivityList(snapshot.data.documents, 
                      favoritesSnapshot.data.documents, 
                      category, 
                      searchText);

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: activities.length,
                      itemBuilder: (BuildContext context, int index) {
                        var activity = activities[index];

                        return PhotoListViewTile(
                            title: activity.name,
                            subtitle: activity.type,
                            imageUrl: activity.imageUrl,
                            showFavoriteIcon: true,
                            isFavorite: favoritesSnapshot.data.documents.any((element) => element.documentID == activity.documentID),
                            onFavorite: () async {
                              await DataService.toggleFavorite(
                                  destination.documentID,
                                  activity.documentID);
                            },
                            routeBuilder: () => MaterialPageRoute(
                              builder: (_) => SitesFoodDetailScreen(
                                destination: destination,
                                activity: activity,
                              ),
                            ));
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
