import 'package:capstone/tripready.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SitesFoodDetailScreen extends StatefulWidget {
  static const routeName = 'sites_food_detail_screen';
  final ActivityModel activity;
  final DestinationModel destination;

  SitesFoodDetailScreen({this.activity, this.destination});

  @override
  _SitesFoodDetailScreenState createState() => _SitesFoodDetailScreenState();
}

class _SitesFoodDetailScreenState extends State<SitesFoodDetailScreen> {
  double rating;

  @override
  void initState() {
    super.initState();

    setState(() {
      rating = widget.activity.rating;
    });
  }

  Widget _buildRatingStars() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [AverageRating(rating: rating), _buildRatingBar()],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text('Your Rating')],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar() {
    return FutureBuilder(
      future: DataService.getUserRating(
          this.widget.destination.documentID, this.widget.activity.documentID),
      builder: (context, AsyncSnapshot<double> snapshot) {
        return RatingBar(
          initialRating: snapshot.hasData ? snapshot.data : 0,
          itemCount: 5,
          allowHalfRating: true,
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) async {
            var updatedActivity = await DataService.addRating(
                this.widget.destination.documentID,
                this.widget.activity.documentID,
                rating);

            setState(() {
              this.rating = updatedActivity.rating;
            });
          },
        );
      },
    );
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
                _buildRatingStars(),
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
