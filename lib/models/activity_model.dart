import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String imageUrl;
  String name;
  String type;
  String category;
  List<String> startTimes;
  int rating;
  int price;

  Activity({this.imageUrl, this.name, this.type, this.category, this.startTimes, this.rating, this.price});

  Activity.fromSnapshot(DocumentSnapshot snapshot) {
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
      'imgaeUrl': imageUrl,
      'name': name,
      'type': type,
      'category': category,
      'startTimes': startTimes,
      'rating': rating,
      'price': price
    };
  }
}

