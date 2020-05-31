import 'package:cloud_firestore/cloud_firestore.dart';

class UserActivityModel {
  String documentID;
  double rating;
  
  UserActivityModel({this.documentID, this.rating});

  UserActivityModel.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    rating = snapshot['rating'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
    };
  }
}
