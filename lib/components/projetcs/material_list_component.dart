import 'package:crochet_land/components/supplies/add_supply_form.dart';
import 'package:crochet_land/components/supplies/supply_list.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/model/supply.dart';
import 'package:crochet_land/services/SupplyService.dart';
import 'package:flutter/material.dart';


class ProjectMaterials extends StatefulWidget {

  static SupplyRepository supplyService = new SupplyRepository();

  final Project project;

  ProjectMaterials(this.project);

  @override
  State<StatefulWidget> createState() {
    return new _ProjectMaterialState(project.suppliesKeys);
  }
}

class _ProjectMaterialState extends State<ProjectMaterials> {

  bool loadingSupplies = true;
  final List<String> supplyKeys;
  List<Supply> supplies = <Supply>[];

  _ProjectMaterialState(this.supplyKeys);

  @override
  void initState() {
    ProjectMaterials.supplyService.loadFromKeys(supplyKeys).then((list) {
      setState(() {
        supplies = list;
        loadingSupplies = false;
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (loadingSupplies) {
      return new Container(padding: new EdgeInsets.all(8.0),
        child: new Center(child: new CircularProgressIndicator()),
      );
    }
    return new Container(padding: new EdgeInsets.all(8.0),
        child: new Column(children: <Widget>[
          supplies.isEmpty ? new Center(
            child: new Text("Adiciona um material vai..."),)
              : new SupplyList(supplies),
          new AddSupplyForm(onAddSupply: (supply) {
            debugPrint("Supply added $supply");
            ProjectMaterials.supplyService.insert(supply);
          },),
        ])
    );
  }
}
