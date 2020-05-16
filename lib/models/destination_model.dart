import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  String imageUrl;
  String city;
  String country;
  String description;
  
  Destination({this.imageUrl, this.city, this.country, this.description});

  Destination.fromSnapshot(DocumentSnapshot snapshot) {
    imageUrl = snapshot['imageUrl'];
    city = snapshot['city'];
    country = snapshot['country'];
    description = snapshot['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'imgaeUrl': imageUrl,
      'city': city,
      'country': country,
      'description': description,
    };
  }
}



