import 'package:capstone/tripready.dart';
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

Text _buildRatingDollars(int price) {
    String dollars = '';
    for (int i = 0; i < price; i++) {
      dollars += '💲';
    }
    dollars.trim();
    return Text(dollars);
  } 
  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: '${this.widget.activity.category}',
      child: Column(
        children: [
          ImageHeader(imageUrl: widget.activity.imageUrl, label: ''),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
      child: buildStack(this.widget.activity, context),
    );
  }

  Stack buildStack(ActivityModel activity, BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                        _buildRatingDollars(activity.price),
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
                SizedBox(height: 10.0),
                //_buildRatingStars(activity.rating),
                AverageRating(rating: activity.rating),
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
      ],
    );
  }
}
