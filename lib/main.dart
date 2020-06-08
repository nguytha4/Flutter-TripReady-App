import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

const String title = 'TripReady';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  
  runApp(App(title: title));
}