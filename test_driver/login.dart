import 'package:crochet_land/components/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';


void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  runApp(new MaterialApp(
    home: new Login(),
    debugShowCheckedModeBanner: false,
  ));
}

