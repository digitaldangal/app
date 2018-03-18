import 'package:crochet_land/components/supplies/edit_supply.dart';
import 'package:crochet_land/model/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Supply supply;

  setUp(() {
    supply = new Supply();
    supply.archived = false;
    supply.name = 'New Supply';
    supply.price = 10.0;
    supply.type = 'Yarn';
  });

  testWidgets('Edit form loads supply info', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(home: new EditSupplyForm(supply)));

    expect(find.text(supply.name), findsOneWidget);
    expect(find.text(supply.price.toString()), findsOneWidget);
    expect(find.text('null'), findsNothing);
  });

  testWidgets('Edit form loads supply price as 0 when price is null', (WidgetTester tester) async {
    supply.price = null;

    await tester.pumpWidget(new MaterialApp(home: new EditSupplyForm(supply)));

    expect(find.text(supply.name), findsOneWidget);
    expect(find.text('0.0'), findsOneWidget);
  });

  testWidgets('Edit form change supply info', (WidgetTester tester) async {
    bool okCalled = false;
    OnOkCallback cb = (newSupply) {
      okCalled = true;
      expect(newSupply, supply);
    };

    await tester.pumpWidget(new MaterialApp(
        home: new EditSupplyForm(
      supply,
      onOK: cb,
    )));

    await tester.enterText(find.text(supply.name), 'pep');

    expect(supply.name, 'pep');

    await tester.enterText(find.text(supply.price.toString()), '1.01');

    expect(supply.price, 1.01);

    await tester.tap(find.text('OK'));

    expect(okCalled, isTrue);
  });
}
