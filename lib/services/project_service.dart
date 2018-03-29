import 'package:crochet_land/services/abstract_firebase_service.dart';
import 'package:crochet_land/stores/project_store.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/project.dart';

class ProjectService extends FirebaseUserAwareCrudRepository<Project> {
  static final ProjectService instance = new ProjectService._private();

  factory ProjectService() => instance;

  ProjectService._private() : super('projects');

  loadMyProjects() async {
    DataSnapshot snapshot = await databaseReference.orderByChild('archived').endAt(false).once();

    (snapshot.value as Map<String, dynamic>).forEach((String key, values) {
      if (values['key'] == null) {
        values['key'] = key;
      }
      ProjectStore.loadProjectAction(new Project.fromValues(values));
    });
  }
}
