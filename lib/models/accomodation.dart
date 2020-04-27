class Accomodation {
  String name;   
  String phoneNum;
  String email;
  String address;
  String confirmNum;  
  DateTime checkInDateTime;
  DateTime checkOutDateTime;

  DateTime timestamp;
  String imageURL;

  Accomodation({
    this.name, this.phoneNum, this.email, this.address, this.confirmNum, this.checkInDateTime, this.checkOutDateTime, 
    this.timestamp, this.imageURL});
}