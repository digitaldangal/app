import 'package:crochet_land/components/projetcs/new_project_form.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:crochet_land/stores/project_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:service_registry/service_registry.dart';
import 'package:validator/validator.dart' show isURL;

import 'mocks.dart';

void main() {
  const VALID_NAME = 'Projeto 1';
  const INVALID_NAME = 'Pr';
  const VALID_DESCRIPTION = 'Descrição Projeto 1';
  // TODO find a better way to show the pattern
//  const VALID_PATTERN_URL = 'http://crochet.land/pattern-1';
//  const INVALID_PATTERN_URL = 'http://croc het.land/patt ern-1';

  ProjectService projectService;
  ProjectStore projectStore = new ProjectStore();
  setUp(() {
    projectService = new MockProjectService();
    ServiceRegistry.registerService(ProjectService, projectService);
    ServiceRegistry.registerService(ProjectStore, projectStore);
  });

  testWidgets('New Project creation', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: new NewProjectForm()));

    await tester.enterText(
        find.ancestor(of: find.text('Nome do projeto'), matching: find.byType(TextFormField)),
        VALID_NAME);

    await tester.pump();

    expect(find.text(VALID_NAME), findsOneWidget);

    await tester.enterText(
        find.ancestor(of: find.text('Descrição básica'), matching: find.byType(TextFormField)),
        VALID_DESCRIPTION);

    expect(find.text(VALID_DESCRIPTION), findsOneWidget);
// TODO find a better way to show the pattern
//    await tester.enterText(find.ancestor(
//        of: find.text('Link pro pattern'),
//        matching: find.byType(TextFormField)),
//        VALID_PATTERN_URL);

//    expect(find.text(VALID_PATTERN_URL), findsOneWidget);

    when(projectService.insert(any)).thenReturn((Project project) {
      expect(project.title, equals(VALID_NAME));
      expect(project.description, equals(VALID_DESCRIPTION));
      // TODO find a better way to show the pattern
//      expect(project.patternUrl, equals(VALID_PATTERN_URL));
      debugPrint(project.toString());
    });

    await tester.tap(find.byType(IconButton));

    await tester.pump();

    verify(projectService.insert(any)).called(1);
  });

  testWidgets('Project invalid name', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: new NewProjectForm()));

    await tester.enterText(
        find.ancestor(of: find.text('Nome do projeto'), matching: find.byType(TextFormField)),
        INVALID_NAME);

    await tester.pump();

    await tester.tap(find.byType(IconButton));

    verifyNever(projectService.insert(any));
  });

  test('test url validator', () {
    expect(isURL('crochet.land'), isTrue);
    expect(isURL('crochet.land/'), isTrue);
    expect(isURL('http://crochet.land'), isTrue);
    expect(isURL('https://crochet.land'), isTrue);
    expect(isURL('https://crochet.land/'), isTrue);
    expect(isURL('https://crochet.land/a'), isTrue);
    expect(isURL('https://crochet.land/a-1/a'), isTrue);
    expect(isURL('https://crochet.land/a-1/a'), isTrue);
    expect(isURL('https://croch et.land/a-1/a'), isFalse);
    expect(isURL('htt://crochet.land/a-1/a'), isFalse);
    expect(isURL('crochet. land/a-1/a'), isFalse);
    expect(isURL('crochet.land/a- 1/a'), isFalse);
  });

// TODO find a better way to show the pattern
//  testWidgets('Project invalid url', (WidgetTester tester) async {
//    await tester.pumpWidget(new MaterialApp(home: new NewProjectForm()));
//
//    await tester.enterText(find.ancestor(
//        of: find.text('Nome do projeto'), matching: find.byType(TextFormField)),
//        VALID_NAME);
//
//    await tester.enterText(find.ancestor(
//        of: find.text('Link pro pattern'),
//        matching: find.byType(TextFormField)),
//        INVALID_PATTERN_URL);
//
//    await tester.pump();
//
//    await tester.tap(find.byType(IconButton));
//
//    verifyNever(projectService.insert(any));
//  });
}
