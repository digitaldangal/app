import 'package:crochet_land/components/supplies/supply_list.dart';
import 'package:crochet_land/model/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Supply list ', (WidgetTester tester) async {
    Supply yarn = new Supply();
    yarn.type = SupplyType.YARN;
    yarn.name = 'Yarn 1';
    yarn.price = 10.0;

    expect(yarn.pricingType, equals(SupplyPricingType.CONSUMABLE));

    Supply hook = new Supply();
    hook.type = SupplyType.HOOK;
    hook.name = 'Hook 1';
    hook.price = 12.0;
    expect(hook.pricingType, equals(SupplyPricingType.DURABLE));

    List<Supply> supplies = <Supply>[yarn, hook, yarn,];

    await tester.pumpWidget(
        new MaterialApp(home: new Scaffold(body: new Column(
          children: <Widget>[new SupplyList(supplies)],

        ))));

    expect(find.text(yarn.name), findsWidgets);
    expect(find.text(hook.name), findsOneWidget);

    await tester.pump();

    State<ExpansionTile> durableTile = tester.state(find
        .byType(ExpansionTile)
        .first);

    expect(durableTile.widget.children.length, 1);
    expect(durableTile.widget.initiallyExpanded, isTrue);


    State<ExpansionTile> consumableTile = tester.state(find
        .byType(ExpansionTile)
        .last);

    expect(consumableTile.widget.children.length, 2);
    expect(consumableTile.widget.initiallyExpanded, isTrue);
  });
}