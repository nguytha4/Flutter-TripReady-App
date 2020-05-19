import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PlanModel {
  String documentID;
  String destinationID;
  DateTime travelDate;

  get travelDateString => DateFormat.yMMMEd().format(travelDate);

  
  PlanModel({this.documentID, this.destinationID, this.travelDate});

  PlanModel.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    destinationID = snapshot['destinationID'];
    travelDate = (snapshot['travelDate'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'destinationID': destinationID,
      'travelDate': travelDate,
    };
  }
}

class PlanTypes {
  static String upcoming = 'Upcoming';
  static String past = 'Past';
}