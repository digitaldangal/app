import 'package:crochet_land/services/auth.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';


class MockAuth extends Mock implements Auth {}


class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockProjectService extends Mock implements ProjectService {}

