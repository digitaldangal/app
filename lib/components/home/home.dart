import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Meus Projetos'),
      ),
      body: new ProjectsList(),
    );
  }
}