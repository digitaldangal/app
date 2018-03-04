import 'dart:async';

import 'package:crochet_land/components/projetcs/project_details.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:crochet_land/routes.dart';


final FirebaseAnalytics analytics = new FirebaseAnalytics();

class ProjectsList extends StatefulWidget {


  @override
  _ProjectsListState createState() => new _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  static ProjectService projectService = new ProjectService();
  List<Project> _projects = [];
  Stream<Project> _projectStream;

  _ProjectsListState() {
    analytics.logViewItemList(itemCategory: 'projects');
  }

  @override
  void initState() {
    _projectStream = new ProjectService().onAddProject();
    _projectStream.listen((project) {
      setState(() {
        this._projects.add(project);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(onPressed: () {
        Routes.router.navigateTo(context, Routes.newProject);
      },
        child: new Icon(Icons.add),
      ),
      body: _projects.length > 0 ? new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
        new _ProjectListItem(_projects[index]),
        itemCount: _projects.length,
      ) : new Center(
        child: new Text('Parece que você ainda não tem nenhum projeto')),
    );
  }
}

class _ProjectListItem extends StatelessWidget {


  final Project _project;

  _ProjectListItem(this._project);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(_project.title[0]),
      ),
      title: new Text(_project.title),
      subtitle: new Text(_project.description),
      trailing: new Icon(Icons.navigate_next),
      onTap: () {
        analytics.logViewItem(itemId: _project.key,
            itemName: _project.title,
            itemCategory: 'projects');
        Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new ProjectWidget(_project.key);
          },
        ));
      },
    );
  }
}
