// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:capstone/widgets/capstone_scaffold.dart';
import 'package:capstone/screens/main_landing_screen.dart';



// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {
  static const routeName = 'login_screen';
  final String title = 'Registration';
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Colors.blue,
              onPressed: () async {
                final FirebaseUser user = await _auth.currentUser();
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                _signOut();

                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _EmailPasswordForm(),
            // _EmailLinkSignInSection(),
            // _AnonymouslySignInSection(),
            _GoogleSignInSection(),
            // _PhoneSignInSection(Scaffold.of(context)),
            // _OtherProvidersSignInSection(),
          ],
        );
      }),
    );
  }

  // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          logo(),
          buildEmailBox(),
          buildPasswordBox(),
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
                  _signInWithEmailAndPassword(context);
                }
              },
                child: const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            )),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _success == null
                  ? ''
                  : (_success
                      ? ''
                      : 'Sign in failed'),
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  Widget logo() {
    return Align(
      alignment: Alignment.center,
      child: Container(
      height: 200,
      width: 200,
      child: Image.asset('assets/images/logo.png')
    )
    ); 
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
                          width: 10
                        ),
                      ),
                      prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue),
                      child: Icon(Icons.email)
                    )
                  )
                    ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ))));
  }

  Widget buildPasswordBox() {
    return Align(
        alignment: Alignment.center,
        child:Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child:Theme(
            data: ThemeData(
              primaryColor: Colors.blue
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
                    fillColor: Colors.blue,
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
                  ),
                  
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          )))
    );
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword(BuildContext context) async {
    FirebaseUser user;
    try {
    user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )).user;
    } 
    catch (err) {
      print(err.toString());
    } 
    finally {
    
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        Navigator.of(context).pushNamed(MainLandingScreen.routeName);
      });
    } else {
      setState(() {
        _success = false;
      });
    }
    }
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  bool _success;
  String _userID;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: RaisedButton(
            
            color: Colors.red,
            onPressed: () async {
              _signInWithGoogle();
            },
            child: const Text('Sign in with Google', style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _success == null
                ? ''
                : (_success
                    ? 'Successfully signed in, uid: ' + _userID
                    : 'Sign in failed'),
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;
        Navigator.of(context).pushNamed(MainLandingScreen.routeName);
      } else {
        _success = false;
      }
    });
  }
}