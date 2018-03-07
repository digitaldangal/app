import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:crochet_land/model/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

void main() {
  Project project;
  setUp(() {
    project = new Project();
    project.timeSpent = 100;
    project.counter = 10;
    project.title = 'Amazing project';
    project.description = 'Amazing project Description';
  });


  testWidgets(
      'Project List Item loads project data', (WidgetTester tester) async {
    MockNavigatorObserver mockNavigatorObserver = new MockNavigatorObserver();

    await tester.pumpWidget(
        new MaterialApp(
          home: new Scaffold(body: new ProjectListItem(project)),
          onGenerateRoute: (_) => null,
          //make sure it doesn't go to anotherp aths
          navigatorObservers: <NavigatorObserver>[
            mockNavigatorObserver,
          ],

        )
    );

    verify(mockNavigatorObserver.didPush(any, any)).called(1);


    expect(find.text(project.title), findsOneWidget);
    expect(find.text(project.description), findsOneWidget);

    await tester.tap(find.text(project.title));
  });
}