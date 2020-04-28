import 'package:flutter/material.dart';
import 'package:capstone/models/destination_model.dart';
import 'package:capstone/screens/destination_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DestinationCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: destinations.length,
        itemBuilder: (BuildContext context, int index) {
          Destination destination = destinations[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DestinationScreen(
                  destination: destination,
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(10.0),
              width: 210.0,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    bottom: 15.0,
                    child: Container(
                      height: 120.0,
                      width: 200.0,
                    ),
                  ),
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
                            tag: destination.imageUrl,
                            child:  Image(
                                height: 180.0,
                                width: MediaQuery.of(context).size.width,
                                image: AssetImage(destination.imageUrl),
                                fit: BoxFit.cover,)),
                          Positioned(
                            child: Container(
                              color: Colors.black26,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      destination.country,
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
                                          destination.city,
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
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
