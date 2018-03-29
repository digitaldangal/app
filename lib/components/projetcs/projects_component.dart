import 'package:crochet_land/components/projetcs/project_details.dart';
import 'package:crochet_land/components/undoable_snack_action.dart';
import 'package:crochet_land/config/routes.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/analytics.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:service_registry/service_registry.dart';

class ProjectsList extends StatefulWidget {

  @override
  _ProjectsListState createState() => new _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  DatabaseReference _projectsRef;

  _ProjectsListState() {
    _projectsRef = ServiceRegistry
        .getService<ProjectService>(ProjectService)
        .databaseReference;
    AnalyticsService.analytics.logViewItemList(itemCategory: 'projects');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Routes.router.navigateTo(context, Routes.newProject);
          },
          child: new Icon(Icons.add),
        ),
        body: new FirebaseAnimatedList(
          query: _projectsRef.orderByChild('archived').endAt(false),
          sort: (a, b) => b.key.compareTo(a.key),
          padding: new EdgeInsets.all(8.0),
          defaultChild: new Center(
            child: new Text('Você ainda não começou nenhum projeto...'),
          ),
          itemBuilder: (context, DataSnapshot snapshot, Animation<double> animation, index) {
            final project = new Project.fromSnapshot(snapshot);
            return new FadeTransition(
                opacity: animation,
                child: new Column(
                  children: <Widget>[
                    new ProjectListItem(project),
                    new Divider(),
                  ],
                ));
          },
        ));
  }
}

class ProjectListItem extends StatelessWidget {
  final ProjectService projectService = ServiceRegistry.getService<ProjectService>(ProjectService);
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
        AnalyticsService.analytics
            .logViewItem(itemId: _project.key, itemName: _project.title, itemCategory: 'projects');
        //TODO maybe we should do a different approach on routing to this, using fluro
        debugPrint('Project tapped');
        Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            debugPrint('Loading project widget');
            return new ProjectWidget(_project);
          },
        ));
      },
      onLongPress: () {
        showModalBottomSheet(
            context: context,
            builder: (btSheetContext) {
              return new Container(
                  child: new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new ListTile(
                            leading: new Icon(Icons.edit),
                            title: new Text(
                              'Editar',
//                              textAlign: TextAlign.center,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .body1,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              //TODO Missing implementation
                              debugPrint('Editing');
                            },
                          ),
                          new ListTile(
                            leading: new Icon(Icons.archive),
                            title: new Text(
                              'Arquivar',
//                              textAlign: TextAlign.center,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .body1,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              showUndoableAction(context, "Projeto arquivado", () {
                                projectService.archive(this._project);
                              });
                            },
                          ),
                          new ListTile(
                            leading: new Icon(Icons.delete),
                            title: new Text(
                              'Remover',
//                              textAlign: TextAlign.center,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: Colors.red),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              showUndoableAction(context, "Projeto removido", () {
                                projectService.delete(this._project);
                              });
                            },
                          ),
                        ],
                      )));
            });
      },
    );
  }
}
