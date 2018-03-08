import 'package:crochet_land/components/supplies/add_supply_form.dart';
import 'package:crochet_land/components/supplies/supply_list.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/model/supply.dart';
import 'package:crochet_land/services/SupplyService.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:flutter/material.dart';


class ProjectMaterials extends StatefulWidget {

  static SupplyRepository supplyService = new SupplyRepository();
  static ProjectService projectService = new ProjectService();

  final Project project;

  ProjectMaterials(this.project);

  @override
  State<StatefulWidget> createState() {
    return new _ProjectMaterialState(project);
  }
}

class _ProjectMaterialState extends State<ProjectMaterials> {

  bool loadingSupplies = true;
  List<Supply> supplies = <Supply>[];
  Project project;
  bool _addingSupply = false;

  _ProjectMaterialState(this.project);

  @override
  void initState() {
    updateSupplies();
    super.initState();
  }

  void updateSupplies() {
    setState(() {
      loadingSupplies = true;
    });
    ProjectMaterials.supplyService.loadFromKeys(project.suppliesKeys)
        .then((list) {
      debugPrint('upaded list $list');
      setState(() {
        supplies = list;
        loadingSupplies = false;
      });
    });
  }

  void _onAddSupply(Supply supply) async {
    setState(() {
      this._addingSupply = true;
    });
    await ProjectMaterials.supplyService.insert(supply);
    debugPrint("Supply added $supply");
    project.addSupply(supply.key);
    await ProjectMaterials.projectService.update(project);


    setState(() {
      this._addingSupply = false;
    });
    updateSupplies();
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
          supplies.isEmpty ? new Expanded(child: new Center(
            child: new Text("Adiciona um material vai..."),))
              : new SupplyList(supplies),
          this._addingSupply ? new Center(
            child: new CircularProgressIndicator(),)
              : new AddSupplyForm(onAddSupply: _onAddSupply,),
        ])
    );
  }
}
