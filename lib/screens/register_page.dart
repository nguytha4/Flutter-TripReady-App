// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:capstone/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/tripready.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  static const routeName = 'register_screen';
  final String title = 'Create Account';
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String errorText = 'Registration failed';
  String _userPassword;
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    return CapstoneScaffold(
      title: widget.title,
      hideDrawer: true,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Logo(),
            buildEmailBox(),
            buildPasswordBox(),
            buildRePasswordBox(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: double.infinity,
                child:RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _register(context);
                  }
                },
                child: const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            )),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                      ? 'Successfully registered ' + _userEmail
                      : errorText)),
            )
          ],
        ),
      )),
    );
  }

  Widget buildPasswordBox() {
    return Align(
        alignment: Alignment.center,
        child:Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child:Theme(
            data: ThemeData(
              primaryColor: Colors.blue,
            ),
            child:TextFormField(
            autofocus: true,
            obscureText: true,
            style: TextStyle(fontSize: 13),
            controller: _passwordController,
            decoration: new InputDecoration(
                    // hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
                    // hintText: "PASSWORD",
                    labelText: "Password",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 10
                      ),
                    ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue),
                      child: Icon(Icons.lock)
                    )
                  )
                    //fillColor: Colors.green
                  ),
                  
            validator: (String value) {
              _userPassword = value.trim();
              if (value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          )))
    );
  }
  
  Align buildRePasswordBox() {
    return Align(
        alignment: Alignment.center,
        child:Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child:Theme(
            data: ThemeData(
              primaryColor: Colors.blue,
            ),
            child:TextFormField(
            style: TextStyle(fontSize: 13),
            obscureText: true,
            controller: _confirmPasswordController,
            decoration: new InputDecoration(
                    labelText: "Re-enter Password",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                      borderSide: new BorderSide(
                        color: Colors.blue,
                        width: 2
                      ),
                    ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue),
                      child: Icon(Icons.lock)
                    )
                  )
                    //fillColor: Colors.green
                    //fillColor: Colors.green
                  ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please re-enter your password';
              } else if (_userPassword != value.trim()) {
                return 'Error: Passwords do not match';
              }
              return null;
            },
          ))));
  }

  Align buildEmailBox() {
    return Align(
          alignment: Alignment.center,
          child:Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child:Theme(
            data: ThemeData(
              primaryColor: Colors.blue
            ),
            child:TextFormField(
            style: TextStyle(fontSize: 13),
            controller: _emailController,
            decoration: new InputDecoration(
                      labelText: "Email",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                        borderSide: new BorderSide(
                          color: Colors.blue,
                          width: 2
                        ),
                      ),
                      prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue),
                      child: Icon(Icons.email)
                    )
                  )
                    //fillColor: Colors.green
                      //fillColor: Colors.green
                    ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ))));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register(BuildContext context) async {
    FirebaseUser user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )).user;
    } catch(err) {
      String errString = err.toString();
      if (errString.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
        setState(() {
          errorText = "Error: Email already in use";
        });
      } else if (errString.contains('ERROR_WEAK_PASSWORD')) {
        setState(() {
          errorText = "Error: Password must be at least 6 characters";
        });
      }
      print(err.toString());
    } finally {
      if (user != null) {
        user = (await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )).user;
        Firestore.instance.collection('users').document(user.uid).setData({
                      'email': _emailController.text.trim(),
                      'password': _passwordController.text.trim(), 
                      'date': DateTime.now(),
                      'uid': user.uid
                    });
        setState(() {
          Navigator.of(context).pop();
          Navigator.of(context).popAndPushNamed(MainLandingScreen.routeName);
          // _success = true;
          // _userEmail = user.email;

        });
      } else {
        _success = false;
      }
    }
  }
}

