import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PlanModel {
  String documentID;
  String destinationID;
  DateTime travelDate;
  DateTime returnDate;

  get travelDateString => DateFormat.yMMMEd().format(travelDate);
  get returnDateString => DateFormat.yMMMEd().format(returnDate);
  
  PlanModel({this.documentID, this.destinationID, this.travelDate, this.returnDate});

  PlanModel.fromSnapshot(DocumentSnapshot snapshot) {
    documentID = snapshot.documentID;
    destinationID = snapshot['destinationID'];
    travelDate = (snapshot['travelDate'] as Timestamp).toDate();
    returnDate = ((snapshot['returnDate'] ?? snapshot['travelDate']) as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'destinationID': destinationID,
      'travelDate': travelDate,
      'returnDate': returnDate,
    };
  }
}

class PlanTypes {
  static String upcoming = 'Upcoming';
  static String past = 'Past';
}