import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:capstone/tripready.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PassportIDForm extends StatefulWidget {
  final DestinationModel destination;
  final PlanModel plan;

  PassportIDForm({this.destination, this.plan});

  @override
  _PassportIDFormState createState() => _PassportIDFormState();
}

class _PassportIDFormState extends State<PassportIDForm> {

  File image;                               // To hold uploaded passport / id image
  final passportID = PassportID();          // Passport object to hold saved values
  final formKey = GlobalKey<FormState>();   // Form key to perform validation / saving
  String userId;

  @override
  void initState() {
    super.initState();
    retrieveDateAndTime();
    getUser();
  }

   @override
  Widget build(BuildContext context) {

    // Responsive design
    final pHeight = MediaQuery.of(context).size.height;
    final pWidth = MediaQuery.of(context).size.width;

    // When page is first opened, user is prompted to upload or take photo of passport / id
    if (image == null) {
      return CapstoneScaffold(
        title: 'Upload Passport / ID',
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              choosePhotoButton(),
              Center(child: Text('or')),
              takePhotoButton(),
            ],
          ),
        );
    }

    // Wait for photo to upload to database once it's been selected
    else if (passportID.imageURL == null) {
      return CapstoneScaffold(
        title: 'Upload Passport / ID',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // When image is uploaded to database, display to user to finalize
    else {
      return CapstoneScaffold(
        title: 'Upload Passport / ID',
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              picture(pHeight, pWidth),
              nameFormField(pHeight, pWidth),
              uploadButton(pHeight, pWidth),
            ],
          )
        ),
      );
    }

  }

  // ====================================== Functions ========================================

  void retrieveDateAndTime() async {
    passportID.timestamp = DateTime.now();
  }

  void getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    uploadImage(image);
    setState( () {} );
  }

  void takePhoto() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    uploadImage(image);
    setState( () {} );
  }

  void uploadImage(File image) async {
    final imageName = DateFormat('yyyy-MM-dd.H.m.s').format(passportID.timestamp);
    StorageReference storageReference =
      FirebaseStorage.instance.ref().child('passportid_' + imageName);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final url = await storageReference.getDownloadURL();
    passportID.imageURL = url;
    setState( () {} );
  }

  void toWalletScreen(BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => WalletScreen(destination: widget.destination)));
  }

  getUser() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userId = user.uid;
      setState(() {});
  }

  // ==================================== Widget functions ====================================

  Widget choosePhotoButton() {
      return RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Choose Photo'),
                onPressed: () { 
                  getImage();
                }
              );
  }

  Widget takePhotoButton() {
      return  RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Take Photo'),
                  onPressed: () { 
                    takePhoto(); 
                  }
                );
  }

  Widget picture(double pHeight, double pWidth) {
    return Padding(
             padding: const EdgeInsets.all(2.0),
             child: Align(
               child: SizedBox(
                 child: Image.file(image),
                 height: pHeight * .7, 
                 width: pWidth * 1,
               ),
               alignment: Alignment.topCenter,
             ),
           );
  }

  Widget nameFormField(double pHeight, double pWidth) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: pWidth * .5,
        height: pHeight * .1,
        child: Form(
          key: formKey,
          child: Theme(
            data: ThemeData(
              primaryColor: Colors.blue
            ),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter Name',
              ),
              onSaved: (value) {
                passportID.name = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a name';
                } else {
                  return null;
                }
              },
            ),
          )
        )
      ),
    );
  }

  Widget uploadButton(double pHeight, double pWidth) {
    return ButtonTheme(
      height: pHeight * .05,
      minWidth: pWidth * .25,
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: Text('Upload'),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();

            Firestore.instance.collection('users').document(userId).collection('plans').document(this.widget.plan.documentID).collection('passportID').add( {
              'timestamp': passportID.timestamp,
              'imageURL': passportID.imageURL,
              'name': passportID.name,
            });

            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // ================================== Functions End ======================================

}