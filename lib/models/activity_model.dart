import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String documentID;
  String imageUrl;
  String name;
  String type;
  String category;
  List<String> startTimes;
  int rating;
  int price;

  ActivityModel({this.documentID, this.imageUrl, this.name, this.type, this.category, this.startTimes, this.rating, this.price});

  ActivityModel.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    imageUrl = snapshot['imageUrl'];
    name = snapshot['name'];
    type = snapshot['type'];
    category = snapshot['category'];
    startTimes  = snapshot['startTimes'].cast<String>();
    rating = snapshot['rating'];
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
      'price': price
    };
  }
}

class ActivityCategories {
  static String sites = 'Sites';
  static String food = 'Food';
  static String favorites = 'Favorites';
}