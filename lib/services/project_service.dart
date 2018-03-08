import 'package:crochet_land/services/abstract_firebase_service.dart';

import '../model/project.dart';


class ProjectService extends FirebaseUserAwareCrudRepository<Project> {

  static final ProjectService _instance = new ProjectService._private();

  factory ProjectService () => _instance;

  ProjectService._private() : super('projects');


}
