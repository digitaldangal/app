import 'package:crochet_land/components/projetcs/project_details.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/routes.dart';
import 'package:crochet_land/services/analytics.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';


class ProjectsList extends StatefulWidget {

  static ProjectService projectService = new ProjectService();

  @override
  _ProjectsListState createState() => new _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {

  DatabaseReference _projectsRef = ProjectsList
      .projectService
      .databaseReference;

  _ProjectsListState() {
    AnalyticsService.analytics.logViewItemList(itemCategory: 'projects');
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
              new ProjectListItem(project),
              new Divider(),
            ],);
          },

        ));
  }
}

class ProjectListItem extends StatelessWidget {


  final Project _project;

  ProjectListItem(this._project);

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
        AnalyticsService
            .analytics.logViewItem(itemId: _project.key,
            itemName: _project.title,
            itemCategory: 'projects'
        );
        //TODO maybe we should do a different approach on routing to this, using fluro
        debugPrint('Project tapped');
        Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            debugPrint('Loading project widget');
            return new ProjectWidget(_project);
          },
        ));
      },
    );
  }
}
