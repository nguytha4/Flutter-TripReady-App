import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:capstone/widgets/capstone_scaffold.dart';

class NewWastePhotoScreen extends StatefulWidget {
  static const routeName = 'new_entry_photo';

  @override
  _NewWastePhotoScreenState createState() => _NewWastePhotoScreenState();
}

class _NewWastePhotoScreenState extends State<NewWastePhotoScreen> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });

    // Navigator.popAndPushNamed(context, NewWasteDetailScreen.routeName, arguments: _image);
  }

  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: 'New Destination Entry',
      child: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      fab: Semantics(
        button: true,
        onTapHint: 'Pick an image from your device''s gallery',
        child: FloatingActionButton(
          key: Key('photo'),
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
      )),
    );
  }
}