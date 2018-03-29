import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:service_registry/service_registry.dart';

class ProjectStore extends Store {
  static Action loadMyProjectsAction = new Action();
  static Action<Project> loadProjectAction = new Action<Project>();

  Set<Project> _projects = new Set<Project>();

  static final ProjectService projectService =
      ServiceRegistry.getService<ProjectService>(ProjectService);

  Set<Project> get projects => new Set<Project>.from(_projects);

  ProjectStore() {
    triggerOnAction(loadProjectAction, (project) {
      if (!_projectLoaded(project)) {
        _projects.add(project);
      }
    });

    loadMyProjectsAction.listen((_) => projectService.loadMyProjects());
  }

  bool _projectLoaded(Project project) {
    return _projects.map((p) => p.key).contains(project.key);
  }
}
