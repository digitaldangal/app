import 'dart:async';

import 'package:crochet_land/components/home/home.dart';
import 'package:crochet_land/components/login/login.dart';
import 'package:crochet_land/routes.dart';
import 'package:crochet_land/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';

final ROUTES = <String, WidgetBuilder>{
  ROUTE_LOGIN: (_) => new Login(), // Login P
  ROUTE_HOME: (_) => new Home(), // age
};

class MyApp extends StatelessWidget {

  // ignore: cancel_subscriptions
  StreamSubscription _loginListener;

  @override
  Widget build(BuildContext context) {
    _setupLoginListener(context);
    return new MaterialApp(
        title: 'Crochet.land',
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        routes: ROUTES
    );
  }


  void _setupLoginListener(BuildContext context) {
    if (_loginListener != null) {
      return;
    }
    _loginListener = auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed(ROUTE_LOGIN);
      }
    });
  }
}


