import 'package:crochet_land/components/projetcs/project_supply_list_component.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/model/supply.dart';
import 'package:crochet_land/services/SupplyService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

void main() {
  Supply yarn;
  Supply hook;


  Project project;
  SupplyRepository supplyService;
  setUp(() {
    supplyService = new MockSupplyService();
    ProjectMaterials.supplyService = supplyService;
    ProjectMaterials.projectService = new MockProjectService();
    project = new Project();
    project.timeSpent = 100;
    project.counter = 10;
    project.title = 'Amazing project';
    project.description = 'Amazing project Description';

    yarn = new Supply();

    yarn.type = 'Yarn';
    yarn.name = 'Yarn 1';
    yarn.price = 10.0;

    hook = new Supply();
    hook.type = 'Hook';
    hook.name = 'Hook 1';
    hook.price = 12.0;
  });
  group("Supply loading tests", () {
    testWidgets(
        'Project Supply list is loading at first', (WidgetTester tester) async {
      MockNavigatorObserver mockNavigatorObserver = new MockNavigatorObserver();


      expect(yarn.pricingType, equals(SupplyPricingType.CONSUMABLE));


      expect(hook.pricingType, equals(SupplyPricingType.DURABLE));

      List<Supply> supplies = <Supply>[yarn, hook,];

      // make sure it takes more than the test execution
      when(supplyService.loadFromKeys(any))
          .thenReturn(new Future.value(supplies));

      await tester.pumpWidget(
          new MaterialApp(
            home: new Scaffold(body: new ProjectMaterials(project)),
            onGenerateRoute: (_) => null,
            //make sure it doesn't go to another paths
            navigatorObservers: <NavigatorObserver>[
              mockNavigatorObserver,
            ],

          ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });


    testWidgets(
        'Project Supply list loads the given supplies', (
        WidgetTester tester) async {
      MockNavigatorObserver mockNavigatorObserver = new MockNavigatorObserver();


      expect(yarn.pricingType, equals(SupplyPricingType.CONSUMABLE));


      expect(hook.pricingType, equals(SupplyPricingType.DURABLE));

      List<Supply> supplies = <Supply>[yarn, hook,];

      when(supplyService.loadFromKeys(any))
          .thenReturn(new Future.value(supplies));

      await tester.pumpWidget(
          new MaterialApp(
            home: new Scaffold(body: new ProjectMaterials(project)),
            onGenerateRoute: (_) => null,
            //make sure it doesn't go to another paths
            navigatorObservers: <NavigatorObserver>[
              mockNavigatorObserver,
            ],

          ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.text(yarn.name), findsWidgets);
      expect(find.text(hook.name), findsWidgets);
    });


    testWidgets(
        'Project Supply loads empty message', (WidgetTester tester) async {
      MockNavigatorObserver mockNavigatorObserver = new MockNavigatorObserver();

      List<Supply> supplies = <Supply>[];

      when(supplyService.loadFromKeys(any))
          .thenReturn(new Future.value(supplies));

      await tester.pumpWidget(
          new MaterialApp(
            home: new Scaffold(body: new ProjectMaterials(project)),
            onGenerateRoute: (_) => null,
            //make sure it doesn't go to another paths
            navigatorObservers: <NavigatorObserver>[
              mockNavigatorObserver,
            ],

          ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.text('Adiciona um material vai...'), findsOneWidget);
    });
  });


  group("Supply list manipulation", () {
    testWidgets(
        'Supply is added to the list', (WidgetTester tester) async {
      MockNavigatorObserver mockNavigatorObserver = new MockNavigatorObserver();
      List<Supply> supplies = <Supply>[];

      when(supplyService.loadFromKeys(any))
          .thenReturn(new Future.value(supplies));

      await tester.pumpWidget(
          new MaterialApp(
            home: new Scaffold(body: new ProjectMaterials(project)),
            onGenerateRoute: (_) => null,
            //make sure it doesn't go to another paths
            navigatorObservers: <NavigatorObserver>[
              mockNavigatorObserver,
            ],

          ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      when(supplyService.insert(any))
          .thenAnswer((_) => supplies.add(yarn));


      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Agulha 1');

      await tester.tap(find.byType(DropdownButton));

      await tester.pump();


      //dropdown animation
      await tester.pump();

      await tester.tap(find
          .text('Linha')
          .last);

      expect(find.text('Agulha 1'), findsOneWidget);

      //dropdown animation
      await tester.pump();

      await tester.tap(find.byType(IconButton));

      await tester.pump();

      verify(supplyService.insert(any)).called(1);
    });
  });
}