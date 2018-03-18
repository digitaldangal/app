import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crochet_land/components/projetcs/project_details.dart';
import 'package:crochet_land/components/undoable_snack_action.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/routes.dart';
import 'package:crochet_land/services/analytics.dart';
import 'package:crochet_land/services/project_repository.dart';
import 'package:flutter/material.dart';

class ProjectsList extends StatefulWidget {
  static ProjectRepository projectService = new ProjectRepository();

  @override
  _ProjectsListState createState() => new _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  CollectionReference _projectsRef = ProjectsList.projectService.databaseReference;

  _ProjectsListState() {
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
        body: new StreamBuilder(
          //TODO fix archived
            stream: _projectsRef.snapshots,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new Center(child: new CircularProgressIndicator());
              }
              debugPrint(snapshot.data.documents.length.toString());
              debugPrint(snapshot.data.documents.toString());


              if (snapshot.data.documents.length == 0) {
                return new Center(
                    child: new Text('Parece que você ainda não comecçou nenhum projeto'));
              }
              return new AnimatedList(
                  padding: new EdgeInsets.all(8.0),
                  initialItemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index, animation) {
                    final project = new Project.fromSnapshot(snapshot.data.documents[index]);
                    debugPrint(project.toString());
                    return new FadeTransition(
                        opacity: animation,
                        child: new Column(
                          children: <Widget>[
                            new ProjectListItem(project),
                            new Divider(),
                          ],
                        ));
                  });
            }));
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
                                ProjectsList.projectService.archive(this._project);
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
                                ProjectsList.projectService.delete(this._project);
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
