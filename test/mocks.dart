import 'package:crochet_land/services/auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';


class MockAuth extends Mock implements Auth {}


class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}



