import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:crochet_land/stores/project_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:service_registry/service_registry.dart';

import 'mocks.dart';

void main() {
  Project project;
  ProjectService projectService;
  ProjectStore projectStore = new ProjectStore();

  setUp(() {
    project = new Project();
    project.timeSpent = 100;
    project.counter = 10;
    project.title = 'Amazing project';
    project.description = 'Amazing project Description';

    projectService = new MockProjectService();

    ServiceRegistry.registerService(ProjectService, projectService);
    ServiceRegistry.registerService(ProjectStore, projectStore);
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

    var called = false;
    ProjectStore.loadMyProjectsAction.listen((_) => called = true);

    await tester.pumpWidget(new MaterialApp(
      home: new Scaffold(body: new ProjectsList()),
      onGenerateRoute: (_) => null,
      //make sure it doesn't go to another paths
      navigatorObservers: <NavigatorObserver>[
        mockNavigatorObserver,
      ],
    ));

    expect(called, isTrue);
  });

  testWidgets('Project loads empty message when project list is empty',
          (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: new Scaffold(body: new ProjectsList()),
    ));

    expect(find.text('Você ainda não começou nenhum projeto...'), findsOneWidget);
  });
}
