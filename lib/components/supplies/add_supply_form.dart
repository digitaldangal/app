import 'package:crochet_land/model/supply.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


/*
TODO tasks pending:
  Clear form not working


 */

typedef void AddSupplyCallback(Supply supply);

class AddSupplyForm extends StatefulWidget {

  AddSupplyCallback onAddSupply = (_) {};


  AddSupplyForm({@required this.onAddSupply});

  @override
  State<StatefulWidget> createState() {
    return new _AddFormSupplyState(onAddSupply);
  }


}


class _AddFormSupplyState extends State<AddSupplyForm> {

  TextEditingController _textController = new TextEditingController();
  Supply _supply = new Supply();
  AddSupplyCallback onAdd = (_) {};

  _AddFormSupplyState(this.onAdd);

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Form(key: formKey, child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Expanded(
            child: new TextField(
                autocorrect: false,
                controller: _textController,
                onChanged: (val) {
                  _supply.name = val;
                },
                decoration: new InputDecoration.collapsed(
                    hintText: 'Nome do material')

            )),
        new DropdownButton(value: _supply.type,
            items: SupplyType.values.map((type) {
              return new DropdownMenuItem<SupplyType>(
                  value: type, child: new Text(supplyTypeNames[type]));
            }).toList(),
            onChanged: (type) {
              setState(() {
                _supply.type = type;
              });
            }),
        new IconButton(icon: new Icon(Icons.add_circle), onPressed: () {
          onAdd(_supply);
          //TODO not reseting the form
          formKey.currentState.reset();
        })
      ],));
  }

}