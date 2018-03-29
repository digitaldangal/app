import 'dart:async';

import 'package:crochet_land/components/login/login.dart';
import 'package:crochet_land/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

void main() {
  MockAuth authMock;

  MockFirebaseAuth mockFirebaseAuth;

  StreamController<MockFirebaseUser> userChangeStreamController;

  loggedOut() {
    userChangeStreamController.add(null);
  }


  loggedIn() {
    var user = new MockFirebaseUser();
    when(user.email).thenReturn('someone@gmail.com');
    userChangeStreamController.add(user);
  }

  setUp(() {
    authMock = new MockAuth();
    mockFirebaseAuth = new MockFirebaseAuth();
    when(authMock.firebaseAuth).thenReturn(mockFirebaseAuth);
    userChangeStreamController = new StreamController<MockFirebaseUser>();

    when(mockFirebaseAuth.onAuthStateChanged).thenReturn(
        userChangeStreamController.stream);

    Login.auth = authMock;
  });

  tearDown(() {
    userChangeStreamController.close();
  });

  testWidgets('Login with Google', (WidgetTester tester) async {
    loggedOut();

    bool routeHomeCalled = false;

    await tester.pumpWidget(new MaterialApp(home: new Login(),
        routes: {Routes.home: (_) {
          routeHomeCalled = true;
          return new Text('route_home');
        }}));

    expect(find.text("Carregando..."), findsOneWidget);

//    await untilCalled(mockFirebaseAuth.onAuthStateChanged);

    await tester.pump();

    Finder loginGoogleFinder = find.text("Login com Google");

    expect(loginGoogleFinder, findsOneWidget);

    when(authMock.signInWithGoogle()).thenAnswer((_) =>
    new Future.value('Happy user'));

    loggedIn();

    await tester.tap(find.ancestor(
        of: loginGoogleFinder, matching: find.byType(RaisedButton)));

    await tester.pump(new Duration(milliseconds: 100));

    expect(routeHomeCalled, true);
  });
}
