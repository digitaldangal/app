import 'package:crochet_land/components/projetcs/project_details.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/routes.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

final FirebaseAnalytics analytics = new FirebaseAnalytics();

class ProjectsList extends StatefulWidget {


  @override
  _ProjectsListState createState() => new _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {

  DatabaseReference _projectsRef = new ProjectService().projectsReference;

  _ProjectsListState() {
    analytics.logViewItemList(itemCategory: 'projects');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(onPressed: () {
          Routes.router.navigateTo(context, Routes.newProject);
        },
          child: new Icon(Icons.add),
        ),
        body: new FirebaseAnimatedList(
          query: _projectsRef,
          sort: (a, b) => b.key.compareTo(a.key),
          padding: new EdgeInsets.all(8.0),
          itemBuilder: (context, DataSnapshot snapshot,
              Animation<double> animation, index) {
            final project = new Project.fromSnapshot(snapshot);
            return new Column(children: <Widget>[
              new _ProjectListItem(project),
              new Divider(),
            ],);
          },

        ));
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
            return new ProjectWidget(_project);
          },
        ));
      },
    );
  }
}
