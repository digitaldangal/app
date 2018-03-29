import 'package:crochet_land/services/analytics.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:service_registry/service_registry.dart';

import '../../config/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crochet.land',
      onGenerateRoute: (routeSettings) =>
          ServiceRegistry.getService<Router>(Router).generator(routeSettings),
      theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
      navigatorObservers: [AnalyticsService.observer],
    );
  }
}
