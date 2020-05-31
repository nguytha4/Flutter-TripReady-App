import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String documentID;
  String imageUrl;
  String name;
  String type;
  String category;
  List<String> startTimes;
  double rating;
  int ratingCount;
  int price;

  ActivityModel({this.documentID, this.imageUrl, this.name, this.type, this.category, this.startTimes, this.rating, this.price});

  ActivityModel.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    imageUrl = snapshot['imageUrl'];
    name = snapshot['name'];
    type = snapshot['type'];
    category = snapshot['category'];
    startTimes  = snapshot['startTimes']?.cast<String>() ?? List<String>();
    rating = double.parse(snapshot['rating'].toString());
    ratingCount = snapshot['ratingCount'] ?? 0;
    price = snapshot['price'];
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'type': type,
      'category': category,
      'startTimes': startTimes,
      'rating': rating,
      'ratingCount': ratingCount,
      'price': price
    };
  }
}

class ActivityCategories {
  static String sites = 'Sites';
  static String food = 'Food';
  static String favorites = 'Favorites';
}