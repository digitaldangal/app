import 'package:crochet_land/routes.dart';
import 'package:crochet_land/services/analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';


class MyApp extends StatelessWidget {


  MyApp() {
    Routes.configureRoutes(Routes.router);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crochet.land',
      onGenerateRoute: (routeSettings) =>
          Routes.router.generator(routeSettings),
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      navigatorObservers: [ AnalyticsService.observer],
    );
  }

}


