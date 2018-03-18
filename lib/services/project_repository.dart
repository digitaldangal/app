import 'package:crochet_land/services/abstract_firebase_service.dart';

import '../model/project.dart';


class ProjectRepository extends FirebaseUserAwareCrudRepository<Project> {

  static final ProjectRepository _instance = new ProjectRepository._private();

  factory ProjectRepository () => _instance;

  ProjectRepository._private() : super('projects');

}
