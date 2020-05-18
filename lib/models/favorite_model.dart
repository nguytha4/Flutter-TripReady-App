import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  String documentID;
  String activityId;
  
  FavoriteModel({this.documentID, this.activityId});

  FavoriteModel.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    activityId = snapshot['activityId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'documentID': documentID,
      'activityId': activityId,
    };
  }
}
