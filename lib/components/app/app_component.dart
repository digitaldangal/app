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



class MyApp extends StatelessWidget {

  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  new FirebaseAnalyticsObserver(analytics: analytics);


  MyApp() {
    Routes.configureRoutes(Routes.router);
  }

  @override
  Widget build(BuildContext context) {
    new FirebaseAnalyticsObserver(analytics: analytics);
    return new MaterialApp(
      title: 'Crochet.land',
      onGenerateRoute: (routeSettings) => Routes.router.generator(routeSettings),
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      navigatorObservers: [ observer],
    );
  }

}


