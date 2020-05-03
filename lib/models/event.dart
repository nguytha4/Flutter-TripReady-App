// A class representing an Event object 
class Event {
  String name;   
  String phoneNum;
  String email;
  String address;
  String confirmNum;  
  DateTime startDateTime;

  DateTime timestamp;
  String imageURL;

  Event({this.name, this.phoneNum, this.email, this.address, this.confirmNum, this.startDateTime, this.timestamp, this.imageURL});
}