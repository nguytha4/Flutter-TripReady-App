import 'package:capstone/models/activity_model.dart';
import 'package:capstone/models/destination_model.dart';
import 'package:capstone/widgets/image_header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SitesFoodDetailScreen extends StatefulWidget {
  static const routeName = 'sites_food_detail_screen';
  final Activity activity;
  final Destination destination;

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
    return Scaffold(
      body: Column(
        children: [
          ImageHeader(imageUrl: widget.activity.imageUrl, label: widget.activity.name),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
            itemCount: widget.destination.activities.length,
            itemBuilder: (BuildContext context, int index) {
              Activity activity = widget.destination.activities[index];
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
            },
          ),
        );
  }
}
