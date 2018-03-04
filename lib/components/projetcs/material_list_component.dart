import 'package:flutter/material.dart';

class ProjectMaterials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(padding: new EdgeInsets.all(20.0),
        child: new Center(child: new Text(
          "Aqui vai aparecer a lista de materiais usados nesse projeto, legal né?",
          textAlign: TextAlign.center,
        ),
        )
    );
  }
}
