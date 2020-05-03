import 'package:capstone/models/activity_model.dart';
import 'package:capstone/screens/sites_food_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone/models/destination_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SitesFoodList extends StatelessWidget {
  final Destination destination;

  const SitesFoodList({Key key, this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: destination.activities.length,
        itemBuilder: (BuildContext context, int index) {
          Activity activity = destination.activities[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SitesFoodDetailScreen(
                  destination: destination,
                  activity: activity,
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(10.0),
              width: 210.0,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Stack(
                        children: [
                          Hero(
                            tag: activity.imageUrl,
                            child:  Image(
                                height: 180.0,
                                width: MediaQuery.of(context).size.width,
                                image: AssetImage(activity.imageUrl),
                                fit: BoxFit.cover,)),
                          buildTitle(context, activity),
                          Positioned(
                    top: 15.0,
                    right: 15.0,
                    child: Icon(
                            FontAwesomeIcons.solidHeart,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        )],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Positioned buildTitle(BuildContext context, Activity activity) {
    return Positioned(
      child: Container(
        color: Colors.black26,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.locationArrow,
                    size: 10.0,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    activity.type,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
