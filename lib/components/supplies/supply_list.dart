import 'package:crochet_land/model/supply.dart';
import 'package:flutter/material.dart';

class SupplyList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SupplyListState();
  }
}


class _SupplyListState extends State<SupplyList> {

  List<Supply> _supplies = <Supply>[];

  @override
  void initState() {
    super.initState();

    setState(() {
      var hook = new Supply();
      hook.type = SupplyType.HOOK;
      hook.name = 'Clover Amour 3.5';
      hook.price = 10.0;
      _supplies.add(hook);

      var yarn = new Supply();
      yarn.type = SupplyType.YARN;
      yarn.name = 'Amigurumi Circulo Amarela';
      yarn.price = 20.0;
      _supplies.add(yarn);
    });
  }

  _buildListTile(Supply supply) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(supplyTypeNames[supply.type][0]),),
      title: new Text(supply.name),
      trailing: new Icon(
          supply.pricingType == SupplyPricingType.DURABLE ? Icons
              .all_inclusive : Icons.refresh),
      subtitle: supply.price != null
          ? new Text('\$${supply.price}')
          : null,

    );
  }

  Widget _buildExpansionTile(List<Supply> supplies, SupplyPricingType type) {
    return new ExpansionTile(
      leading: new Icon(supplyPricingTypeIcons[type]),
      initiallyExpanded: true,
      title: new Text(supplyPricingTypeNames[type]),
      children: supplies.map(_buildListTile).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var durableSupplies = _supplies.where((e) =>
    e.pricingType == SupplyPricingType.DURABLE).toList();
    var consumableSupplies = _supplies.where((e) =>
    e.pricingType == SupplyPricingType.CONSUMABLE).toList();

    return new Expanded(child: new Column(children: <Widget>[
      _buildExpansionTile(durableSupplies, SupplyPricingType.DURABLE),
      _buildExpansionTile(consumableSupplies, SupplyPricingType.CONSUMABLE),
    ],));

//    return new Expanded(
//        child: new ListView.builder(
//            itemCount: _supplies.length,
//            itemBuilder: (context, index) {
//              final supply = _supplies[index];
//
//            }));
  }


}