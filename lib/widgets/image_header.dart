import 'package:flutter/material.dart';
import 'package:capstone/tripready.dart';

class ImageHeader extends StatelessWidget {
  const ImageHeader({
    Key key,
    @required this.imageUrl,
    @required this.label,
  }) : super(key: key);

  final String imageUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.width - 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Hero(
              tag: imageUrl,
              child: Image(
                image: ImageService.buildAssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black45,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
