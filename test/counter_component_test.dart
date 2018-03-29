import 'package:crochet_land/components/projetcs/counter_component.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:crochet_land/stores/project_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_registry/service_registry.dart';

import 'mocks.dart';

void main() {
  Project project;
  ProjectStore projectStore = new ProjectStore();
  setUp(() {
    ServiceRegistry.registerService<ProjectService>(ProjectService, new MockProjectService());
    ServiceRegistry.registerService<ProjectStore>(ProjectStore, projectStore);

    project = new Project();
    project.timeSpent = 100;
    project.counter = 10;
  });

  testWidgets('Timer starts and stops', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: new CounterComponent(project)));

    await tester.pump(new Duration(milliseconds: 250));

    expect(find.text('Iniciar'), findsOneWidget);
    expect(find.text('Pausar'), findsNothing);

    await tester.tap(find.ancestor(of: find.text('Iniciar'), matching: find.byType(RaisedButton)));

    await tester.pump(new Duration(seconds: 2));
    expect(find.text('Pausar'), findsOneWidget);
    expect(find.text('Iniciar'), findsNothing);

    await tester.pump();

    await tester.tap(find.ancestor(of: find.text('Pausar'), matching: find.byType(RaisedButton)));

    await tester.pump();
    expect(projectStore.isCountingTime(project), isFalse);
    expect(find.text('Iniciar'), findsOneWidget);
    expect(find.text('Pausar'), findsNothing);

    expect(project.timeSpent, greaterThan(100));
  });

  testWidgets('Counter increases', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: new CounterComponent(project)));

    await tester.pump(new Duration(milliseconds: 250));

    debugPrint(project.toMap().toString());
    await tester.tap(find.text('+1'));

    await tester.pump(new Duration(milliseconds: 200));

    expect(project.counter, 11);

    expect(find.text('11'), findsOneWidget);
  });

  testWidgets('Counter decreases', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: new CounterComponent(project)));

    await tester.pump(new Duration(milliseconds: 250));

    await tester.tap(find.text('-1'));

    await tester.pump();

    expect(find.text('9'), findsOneWidget);

    expect(project.counter, 9);
  });

  testWidgets('Timer counter to zero', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: new CounterComponent(project)));

    await tester.pump(new Duration(milliseconds: 250));

    await tester.longPress(find.text('-1'));

    await tester.pump();

    expect(find.text('0'), findsOneWidget);

    expect(project.counter, 0);
  });
}
