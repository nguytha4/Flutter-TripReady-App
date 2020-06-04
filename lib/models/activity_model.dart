import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String documentID;
  String imageUrl;
  String name;
  String type;
  String category;
  String description;
  String url;
  double rating;
  int ratingCount;
  int price;

  ActivityModel({this.documentID, this.imageUrl, this.name, this.type, this.category, this.description, this.rating, this.price, this.url});

  ActivityModel.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    imageUrl = snapshot['imageUrl'];
    name = snapshot['name'];
    type = snapshot['type'];
    category = snapshot['category'];
    description  = snapshot['description'] ?? 'Named as a must visit place by travellers all around the world. There are a million things to experience here. It\'s a guaranteed place to have fun and enjoy every minute of your time. Maybe you\'ve indulged yourself before, but not quite like this. Give it a shot and find yourself here.';
    rating = double.parse(snapshot['rating'].toString());
    ratingCount = snapshot['ratingCount'] ?? 1;
    price = snapshot['price'];
    url = snapshot['url'] ?? 'https://google.com';
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'type': type,
      'category': category,
      'description': description,
      'rating': rating,
      'ratingCount': ratingCount,
      'price': price,
      'url': url
    };
  }
}

class ActivityCategories {
  static String sites = 'Sites';
  static String food = 'Food';
  static String favorites = 'Favorites';
}