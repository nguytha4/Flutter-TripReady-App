// A class representing a transit object 
class Transit {
  String name;   
  String startLocation;
  String destination;
  String confirmNum; 
  DateTime departDateTime;
  DateTime arriveDateTime;

  DateTime timestamp;
  String imageURL;

  Transit({this.name, this.startLocation, this.destination, this.confirmNum, this.departDateTime, this.arriveDateTime, 
  this.timestamp, this.imageURL});
}