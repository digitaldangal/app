import 'package:crochet_land/components/supplies/edit_supply.dart';
import 'package:crochet_land/model/supply.dart';
import 'package:crochet_land/services/SupplyService.dart';
import 'package:flutter/material.dart';
import 'package:service_registry/service_registry.dart';

class SupplyList extends StatefulWidget {
  final SupplyRepository supplyRepository = ServiceRegistry.getService(SupplyRepository);

  final List<Supply> supplies;

  SupplyList(this.supplies);

  @override
  State<StatefulWidget> createState() {
    return new _SupplyListState(supplies);
  }
}

class _SupplyListState extends State<SupplyList> {
  final List<Supply> _supplies;

  _SupplyListState(this._supplies);

  _buildListTile(Supply supply) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(supplyTypeNames[supply.type][0]),
      ),
      title: new Text(supply.name),
      trailing: new Icon(supplyPricingTypeIcons[supply.pricingType]),
      subtitle: supply.price != null ? new Text('\$${supply.price}') : null,
      onTap: () {
        showDialog(
            context: context,
            child: new EditSupplyForm(
              supply,
              onOK: (updatedSupply) async {
                Navigator.of(context).pop();
                widget.supplyRepository.update(updatedSupply);
              },
            ));
      },
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
    var durableSupplies =
    _supplies.where((e) => e.pricingType == SupplyPricingType.DURABLE).toList();
    var consumableSupplies =
    _supplies.where((e) => e.pricingType == SupplyPricingType.CONSUMABLE).toList();

    return new Flexible(
        child: new Column(
          children: <Widget>[
            _buildExpansionTile(durableSupplies, SupplyPricingType.DURABLE),
            _buildExpansionTile(consumableSupplies, SupplyPricingType.CONSUMABLE),
          ],
        ));
  }
}
