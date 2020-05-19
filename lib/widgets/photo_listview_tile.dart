import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PhotoListViewTile extends StatelessWidget {
  const PhotoListViewTile(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.imageUrl,
      @required this.route,
      this.showFavoriteIcon = false,
      this.isFavorite = false,
      this.onFavorite})
      : super(key: key);

  final String title;
  final String subtitle;
  final String imageUrl;
  final Route route;
  final bool showFavoriteIcon;
  final bool isFavorite;
  final Function onFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        route,
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
                        tag: imageUrl,
                        child: Image(
                          height: 180.0,
                          width: MediaQuery.of(context).size.width,
                          image: AssetImage(imageUrl),
                          fit: BoxFit.cover,
                        )),
                    PhotoListViewTileTitle(
                        context: context, title: title, subtitle: subtitle),
                    Visibility(
                      visible: showFavoriteIcon,
                      child: Positioned(
                        top: 15.0,
                        right: 15.0,
                        child: GestureDetector(
                          onTap: onFavorite,
                          child: Icon(
                            FontAwesomeIcons.solidHeart,
                            size: 20.0,
                            color: isFavorite ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoListViewTileTitle extends StatelessWidget {
  const PhotoListViewTileTitle({
    Key key,
    @required this.context,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
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
                title,
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
                    subtitle,
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
