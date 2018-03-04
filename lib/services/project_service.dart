import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../model/project.dart';
import '../services/auth.dart';


class ProjectService {

  static final auth = new Auth();
  static final ProjectService _instance = new ProjectService._private();

  factory ProjectService () => _instance;


  DatabaseReference projectsReference;

  ProjectService._private(){
    projectsReference =
        FirebaseDatabase.instance
            .reference()
            .child(auth.user.uid)
            .child('projects');
  }


  addProject(Project project) async {
    //TODO add to firebase
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
