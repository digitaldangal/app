// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'dart:async';

import 'package:crochet_land/components/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

void main() {
  testWidgets('Login loads test', (WidgetTester tester) async {
    // Build our app and trigger a frame.


    MockAuth authMock = new MockAuth();

    MockFirebaseAuth mockFirebaseAuth = new MockFirebaseAuth();

    Login.auth = authMock;

    when(authMock.firebaseAuth).thenReturn(mockFirebaseAuth);

    when(mockFirebaseAuth.onAuthStateChanged)
        .thenReturn(
        new Stream.fromFuture(new Future.value(null))
    );


    await tester.pumpWidget(new MaterialApp(home: new Login(),));

    expect(find.text("Carregando..."), findsOneWidget);

    await untilCalled(mockFirebaseAuth.onAuthStateChanged);

    await tester.pump();

    Finder loginGoogleFinder = find.text("Login com Google");

    expect(loginGoogleFinder, findsOneWidget);


    when(authMock.signInWithGoogle()).thenAnswer((_) =>
    new Future.value('Happy user'));

    await tester.tap(find.ancestor(
        of: loginGoogleFinder, matching: find.byType(RaisedButton)));

    await tester.pump();

    verify(authMock.signInWithGoogle()).called(1);
  });
}
