// A class representing a passport / id object 
class PassportID {
  String name;      // Name of the person that passport / id belongs to
  String imageURL;  // ImageURL of the uploaded passport / id photo
  DateTime timestamp;  // To use for timestamp that 

  PassportID({this.name, this.imageURL, this.timestamp});
}