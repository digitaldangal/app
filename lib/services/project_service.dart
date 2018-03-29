import 'package:crochet_land/services/abstract_firebase_service.dart';
import 'package:crochet_land/stores/project_store.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/project.dart';

class ProjectService extends FirebaseUserAwareCrudRepository<Project> {
  static final ProjectService instance = new ProjectService._private();

  factory ProjectService() => instance;

  ProjectService._private() : super('projects');

  loadMyProjects() async {
    var query = databaseReference.orderByChild('archived').endAt(false);

    DataSnapshot snapshot = await query.once();

    (snapshot.value as Map<String, dynamic>).forEach(
            (String key, values) => ProjectStore.loadProjectAction(new Project.fromValues(values)));
  }
}
