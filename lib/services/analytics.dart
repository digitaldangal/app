import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';


class AnalyticsService {

  static FirebaseAnalytics analytics = new FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = new FirebaseAnalyticsObserver(
      analytics: AnalyticsService.analytics);

}