import 'package:cloud_firestore/cloud_firestore.dart';

class StarModel {
  String documentID;
  String activityId;
  
  StarModel({this.documentID, this.activityId});

  StarModel.fromSnapshot(DocumentSnapshot snapshot) {
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
