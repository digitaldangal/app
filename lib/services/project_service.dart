import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../model/project.dart';
import '../services/auth.dart';


class ProjectService {

  static Auth auth = new Auth();
  static final ProjectService _instance = new ProjectService._private();

  static FirebaseDatabase firebase = FirebaseDatabase.instance;

  factory ProjectService () => _instance;


  DatabaseReference projectsReference;

  ProjectService._private(){
    projectsReference =
        firebase
            .reference()
            .child(auth.user.uid)
            .child('projects');
  }


  addProject(Project project) async {
    assert(project != null);
    assert(project.title != null);
    //simulate network
    await new Future.delayed(new Duration(seconds: 2), () {});
    final newProjectRef = projectsReference.push();
    project.key ??= newProjectRef.key;
    newProjectRef.set(project.toMap());
  }

  void update(Project project) {
    projectsReference.child(project.key).update(project.toMap());
  }


}
