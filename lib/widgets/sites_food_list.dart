import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class SitesFoodList extends StatelessWidget {
  final DestinationModel destination;
  final String category;
  final String searchText;

  const SitesFoodList(
      {Key key, this.destination, this.category, this.searchText})
      : super(key: key);

  List<ActivityModel> buildActivityList(
      List<ActivityModel> allActivities,
      List<String> favoriteIds,
      String category,
      String searchText) {
    List<ActivityModel> activities = List<ActivityModel>();

    // build full tab
    if (category == ActivityCategories.favorites) {
      for (var id in favoriteIds) {
        activities.add(allActivities.singleWhere((element) => element.documentID == id));
      }
    } else {
      activities.addAll(
          allActivities.where((activity) => activity.category == category));
    }

    // filter results for this tab
    if (searchText == null || searchText.isEmpty) {
      return activities;
    } else {
      return activities.where((activity) =>
          activity.name.toLowerCase().contains(searchText.toLowerCase())).toList();
    }
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

                List<String> favoriteIds =
                    (favoritesSnapshot.data.documents as List<DocumentSnapshot>)
                        .map((snapshotItem) => snapshotItem.documentID)
                        .toList();

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

                    List<ActivityModel> allActivities = (snapshot.data.documents as List<DocumentSnapshot>)
                        .map((snapshotItem) => ActivityModel.fromSnapshot(snapshotItem))
                        .toList();

                    var activities = buildActivityList(allActivities,
                        favoriteIds, category, searchText);

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
                            isFavorite: favoriteIds.any((f) => f == activity.documentID),
                            onFavorite: () async {
                              await DataService.toggleFavorite(
                                  destination.documentID, activity.documentID);
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
