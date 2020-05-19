import 'package:capstone/tripready.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SitesFoodDetailScreen extends StatefulWidget {
  static const routeName = 'sites_food_detail_screen';
  final ActivityModel activity;
  final DestinationModel destination;

  SitesFoodDetailScreen({this.activity, this.destination});

  @override
  _SitesFoodDetailScreenState createState() => _SitesFoodDetailScreenState();
}

class _SitesFoodDetailScreenState extends State<SitesFoodDetailScreen> {
  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: '${this.widget.activity.category}',
      child: Column(
        children: [
          ImageHeader(
              imageUrl: widget.activity.imageUrl, label: widget.activity.name),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('activity')
              .orderBy('name')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.documents.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  var snapshotItem = snapshot.data.documents[index];
                  var activity = ActivityModel.fromSnapshot(snapshotItem);

                  return buildStack(activity, context);
                },
              );
            } else {
              return Center(
                  child: Column(children: [
                Text('No items. Please click the button below')
              ]));
            }
          }),
    );
  }

  Stack buildStack(ActivityModel activity, BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
          height: 170.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.0,
                      child: Text(
                        activity.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '\$${activity.price}',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'per pax',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  activity.type,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                _buildRatingStars(activity.rating),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: 85.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        activity.startTimes[0],
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: 85.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        activity.startTimes[1],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 20.0,
          top: 15.0,
          bottom: 15.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              width: 110.0,
              image: AssetImage(
                activity.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
