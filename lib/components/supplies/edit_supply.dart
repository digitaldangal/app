import 'package:crochet_land/components/supplies/supply_type_dropdown.dart';
import 'package:crochet_land/model/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void OnOkCallback(Supply supply);

class EditSupplyForm extends StatefulWidget {
  final Supply supply;
  final OnOkCallback onOK;

  EditSupplyForm(this.supply, {this.onOK}) : assert(supply != null);

  @override
  _EditSupplyFormState createState() => new _EditSupplyFormState(supply, onOK);
}

class _EditSupplyFormState extends State<EditSupplyForm> {
  final Supply supply;
  final OnOkCallback onOK;

  TextEditingController supplyNameController;
  TextEditingController supplyPriceController;

  _EditSupplyFormState(this.supply, this.onOK);

  @override
  void initState() {
    supplyNameController = new TextEditingController(text: supply.name);
    supplyNameController.addListener(() => supply.name = supplyNameController.text);
    supplyPriceController = new TextEditingController(text: supply.price?.toString() ?? '0');
    supplyPriceController
        .addListener(() => supply.price = double.parse(supplyPriceController.text).toDouble());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Editar Material'),
      content: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new TextField(
            controller: supplyNameController,
            decoration: new InputDecoration(labelText: 'Nome'),
          ),
          new TextField(
            controller: supplyPriceController,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Preço',
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(top: 16.0), child: new SupplyFormDropdown(supply))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            if (this.onOK != null) {
              this.onOK(supply);
            }
          },
          child: new Text('OK'),
        )
      ],
    );
  }
}
