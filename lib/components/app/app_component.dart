import 'package:crochet_land/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';



class MyApp extends StatelessWidget {

  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = new FirebaseAnalyticsObserver(
      analytics: analytics);


  MyApp() {
    Routes.configureRoutes(Routes.router);
  }

  @override
  Widget build(BuildContext context) {
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


