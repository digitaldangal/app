import 'package:crochet_land/services/SupplyService.dart';
import 'package:crochet_land/services/auth.dart';
import 'package:crochet_land/services/project_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';


class MockAuth extends Mock implements Auth {}


class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockProjectService extends Mock implements ProjectRepository {}

class MockSupplyService extends Mock implements SupplyRepository {}