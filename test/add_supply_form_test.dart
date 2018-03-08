import 'package:crochet_land/components/supplies/add_supply_form.dart';
import 'package:crochet_land/model/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add supply form can add supply', (WidgetTester tester) async {
    var calledAdd = false;
    var onAddSupply = (Supply supply) {
      debugPrint('test callback called');
      calledAdd = true;
      expect(supply.name, 'Agulha 1');
      expect(supply.type, 'Yarn');
    };

    await tester.pumpWidget(
        new MaterialApp(home: new Scaffold(
            body: new AddSupplyForm(onAddSupply: onAddSupply,))));


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

    expect(calledAdd, isTrue);

    //clean form
    expect(find.text('Agulha 1'), findsNothing);
  });
}