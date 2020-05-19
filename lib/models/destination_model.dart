import 'package:cloud_firestore/cloud_firestore.dart';

class DestinationModel {
  String documentID;
  String imageUrl;
  String city;
  String country;
  String description;
  
  DestinationModel({this.imageUrl, this.city, this.country, this.description, this.documentID});

  DestinationModel.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    imageUrl = snapshot['imageUrl'];
    city = snapshot['city'];
    country = snapshot['country'];
    description = snapshot['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'city': city,
      'country': country,
      'description': description,
    };
  }
}



