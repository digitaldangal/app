import 'package:crochet_land/components/supplies/add_supply_form.dart';
import 'package:crochet_land/components/supplies/supply_list.dart';
import 'package:flutter/material.dart';


class ProjectMaterials extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ProjectMaterialState();
  }
}

class _ProjectMaterialState extends State<ProjectMaterials> {


  @override
  Widget build(BuildContext context) {
    return new Container(padding: new EdgeInsets.all(8.0),
        child: new Column(children: <Widget>[
          new SupplyList(),
          new Expanded(child:
          new Column(
            children: <Widget>[
              new Divider(), new AddSupplyForm(onAddSupply: (supply) {
                // TODO actually saved something
                debugPrint('$supply added');
              },),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          )),

        ])
    );
  }
}
