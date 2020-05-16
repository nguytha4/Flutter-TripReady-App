import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  String documentID;
  String imageUrl;
  String city;
  String country;
  String description;
  
  Destination({this.imageUrl, this.city, this.country, this.description, this.documentID});

  Destination.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    imageUrl = snapshot['imageUrl'];
    city = snapshot['city'];
    country = snapshot['country'];
    description = snapshot['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'documentID' : documentID,
      'imageUrl': imageUrl,
      'city': city,
      'country': country,
      'description': description,
    };
  }
}



