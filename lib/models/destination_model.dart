import 'package:capstone/models/activity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  String imageUrl;
  String city;
  String country;
  String description;
  List<Activity> activities;
  
  Destination({this.imageUrl, this.city, this.country, this.description, this.activities});

  Destination.fromSnapshot(DocumentSnapshot snapshot) {
    imageUrl = snapshot['imageUrl'];
    city = snapshot['city'];
    country = snapshot['country'];
    description = snapshot['description'];
    //activities = snapshot['activities'];
  }

  Map<String, dynamic> toMap() {
    return {
      'imgaeUrl': imageUrl,
      'city': city,
      'country': country,
      'description': description,
      //'activities': activities
    };
  }
}



