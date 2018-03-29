import 'dart:async';

import 'package:crochet_land/components/login/login.dart';
import 'package:crochet_land/config/routes.dart';
import 'package:crochet_land/services/auth.dart';
import 'package:crochet_land/stores/user_store.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:service_registry/service_registry.dart';

import 'mocks.dart';

void main() {
  MockAuth authMock;

  UserStore userStore;

  Router router;

  setUp(() {
    userStore = new UserStore();
    authMock = new MockAuth();
    router = new Router();

    ServiceRegistry.registerService(Router, router);
    ServiceRegistry.registerService(UserStore, userStore);
//    ServiceRegistry.registerService(FirebaseAuth, mockFirebaseAuth);
    ServiceRegistry.registerService(AuthenticationService, authMock);
  });

  loggedOut() async {
    await UserStore.updateUserAction(null);
  }

  loggedIn() async {
    var user = new MockFirebaseUser();
    when(user.email).thenReturn('someone@gmail.com');
    await UserStore.updateUserAction(user);
  }

  testWidgets('Login with Google', (WidgetTester tester) async {
    await loggedOut();

    bool routeHomeCalled = false;

    router.define(Routes.home,
        handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          routeHomeCalled = true;
          return new Text("Home");
        }));

    await tester.pumpWidget(
      new MaterialApp(home: new Login(), onGenerateRoute: (_) => router.generator(_)),
    );

    expect(find.text("Carregando..."), findsOneWidget);

    await tester.pump();

    Finder loginGoogleFinder = find.text("Login com Google");

    expect(loginGoogleFinder, findsOneWidget);

    when(authMock.signInWithGoogle()).thenAnswer((_) => new Future.value('Happy user'));

    loggedIn();

    await tester.tap(find.ancestor(of: loginGoogleFinder, matching: find.byType(RaisedButton)));

    await tester.pump(new Duration(milliseconds: 100));

    expect(routeHomeCalled, true);
  });
}
