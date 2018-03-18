import 'package:crochet_land/model/supply.dart';
import 'package:flutter/material.dart';

class SupplyFormDropdown extends StatefulWidget {
  final Supply supply;

  SupplyFormDropdown(this.supply);

  @override
  _SupplyFormDropdownState createState() => new _SupplyFormDropdownState(supply);
}

class _SupplyFormDropdownState extends State<SupplyFormDropdown> {
  final Supply _supply;

  _SupplyFormDropdownState(this._supply);

  @override
  Widget build(BuildContext context) {
    return new DropdownButton(
        value: _supply.type,
        items: supplyTypes.map((type) {
          return new DropdownMenuItem<String>(value: type, child: new Text(supplyTypeNames[type]));
        }).toList(),
        onChanged: (type) {
          setState(() {
            _supply.type = type;
          });
        });
  }
}
