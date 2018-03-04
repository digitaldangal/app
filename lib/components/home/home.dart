import 'package:flutter/material.dart';

import '../drawer.dart';
import '../projetcs/projects_component.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Meus Projetos'),
      ),
      body: new ProjectsList(),
      drawer: new Drawer(child: new AppDrawer(),),
    );
  }
}