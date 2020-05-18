import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  static Future<String> currentUserId() async {
    var user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }
}
