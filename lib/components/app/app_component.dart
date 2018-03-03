import 'dart:async';

import 'package:crochet_land/components/home/home.dart';
import 'package:crochet_land/components/login/login.dart';
import 'package:crochet_land/routes.dart';
import 'package:crochet_land/services/auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';

import '../../config/theme.dart';

final ROUTES = <String, WidgetBuilder>{
  ROUTE_LOGIN: (_) => new Login(),
  ROUTE_HOME: (_) => new Home(),
};

class MyApp extends StatelessWidget {

  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  new FirebaseAnalyticsObserver(analytics: analytics);


  // ignore: cancel_subscriptions
  StreamSubscription _loginListener;

  @override
  Widget build(BuildContext context) {
    _setupLoginListener(context);

    new FirebaseAnalyticsObserver(analytics: analytics);
    return new MaterialApp(
      title: 'Crochet.land',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      routes: ROUTES,
      navigatorObservers: [ observer],
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


