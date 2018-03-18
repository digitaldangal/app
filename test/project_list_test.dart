import 'dart:async';

import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

void main() {
  Project project;
  MockDatabaseReference databaseReference;
  ProjectRepository projectService;

  setUp(() {
    project = new Project();
    project.timeSpent = 100;
    project.counter = 10;
    project.title = 'Amazing project';
    project.description = 'Amazing project Description';

    databaseReference = new MockDatabaseReference();
    projectService = new MockProjectService();
    when(projectService.databaseReference).thenReturn(databaseReference);

    when(databaseReference.orderByChild(any)).thenReturn(databaseReference);
    when(databaseReference.endAt(any)).thenReturn(databaseReference);
  });

  testWidgets('Project List Item loads project data', (WidgetTester tester) async {
    MockNavigatorObserver mockNavigatorObserver = new MockNavigatorObserver();

    await tester.pumpWidget(new MaterialApp(
      home: new Scaffold(body: new ProjectListItem(project)),
      onGenerateRoute: (_) => null,
      //make sure it doesn't go to another paths
      navigatorObservers: <NavigatorObserver>[
        mockNavigatorObserver,
      ],
    ));

    verify(mockNavigatorObserver.didPush(any, any)).called(1);

    expect(find.text(project.title), findsOneWidget);
    expect(find.text(project.description), findsOneWidget);

    await tester.tap(find.text(project.title));
  });

  testWidgets('Project List Item loads project data', (WidgetTester tester) async {
    MockNavigatorObserver mockNavigatorObserver = new MockNavigatorObserver();

    ProjectsList.projectService = projectService;

    await tester.pumpWidget(new MaterialApp(
      home: new Scaffold(body: new ProjectsList()),
      onGenerateRoute: (_) => null,
      //make sure it doesn't go to another paths
      navigatorObservers: <NavigatorObserver>[
        mockNavigatorObserver,
      ],
    ));

    verify(databaseReference.onValue).called(greaterThan(0));

    //TODO this test right now is too poor, doesn't actually test it loads, but I don't want to test the FirebaseAnimatedList
  });

  testWidgets('Project loads empty message when project list is empty',
          (WidgetTester tester) async {
    ProjectsList.projectService = projectService;

    when(projectService.databaseReference).thenReturn(databaseReference);

    when(databaseReference.onValue).thenAnswer((_) => new Stream.empty());

    await tester.pumpWidget(new MaterialApp(
      home: new Scaffold(body: new ProjectsList()),
    ));

    verify(databaseReference.onValue).called(greaterThan(0));

    expect(find.text('Você ainda não começou nenhum projeto...'), findsOneWidget);
  });
}
