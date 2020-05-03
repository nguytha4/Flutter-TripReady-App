import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Container(
    child: Image.asset('assets/images/mainlogo.png', height: 300, width: 300,)
  )
  ); 
}
}