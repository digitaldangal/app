import 'dart:async';

import '../model/project.dart';

class ProjectService {

  static ProjectService _instance = new ProjectService._private();

  factory ProjectService () => _instance;

  StreamController<Project> _addProjectStreamController = new StreamController<
      Project>();


  //TODO get from firebase
  var _projects = <String, Project>{
    '1': new Project(
        key: '1',
        title: 'Descolado 1',
        description: 'Algo de girafa mesmo',
        timeSpent: 59,
        patternUrl: "https://crochet.land/tiara-de-girafa-desafiodescolado-descolandogirafas/"),
    '2': new Project(
        key: '2',
        title: 'Super descolado 2',
        description: 'Algo ainda mais incrível de girafa',
        timeSpent: 119)
  };

  ProjectService._private(){
    _projects.forEach((key, project) =>
        _addProjectStreamController.add(project));
  }

  addProject(Project project) async {
    //TODO add to firebase
    assert(project != null);
    assert(project.title != null);
    //simulate network
    await new Future.delayed(new Duration(seconds: 2), () {});
    final key = project.key ?? project.hashCode.toString();
    project.key ??= key;
    project.timeSpent ??= 0;
    project.counter ??= 0;
    _projects[key] = project;
    _addProjectStreamController.add(project);
  }


//  Map<String, Project> get projects {
//    return _projects;
//  }

  Future<Project> getProject(String key) async {
    return _projects[key];
  }

  Stream<Project> onAddProject() {
    return _addProjectStreamController.stream;
  }
}
