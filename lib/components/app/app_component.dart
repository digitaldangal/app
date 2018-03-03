import 'dart:async';

import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:crochet_land/components/login/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../config/theme.dart';

final googleSignIn = new GoogleSignIn();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Crochet.land',
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        routes: <String, WidgetBuilder>{
          '/': (_) => new SplashScreen(), // Login P
          '/home': (_) => new Home(), // age
        });
  }
}


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Meus Projetos'),
      ),
      body: new ProjectsList(),
    );
  }
}
