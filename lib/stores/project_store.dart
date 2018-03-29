import 'dart:async';

import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:service_registry/service_registry.dart';

class ProjectStore extends Store {
  static Action loadMyProjectsAction = new Action();
  static Action<Project> loadProjectAction = new Action<Project>();
  static Action<Project> startTimerAction = new Action<Project>();
  static Action<Project> stopTimerAction = new Action<Project>();
  static Action<Project> increaseCounterAction = new Action<Project>();
  static Action<Project> decreaseCounterAction = new Action<Project>();
  static Action<Project> resetCounterAction = new Action<Project>();
  static Action<Project> createProjectAction = new Action<Project>();

  static final ProjectService projectService =
  ServiceRegistry.getService<ProjectService>(ProjectService);

  Set<Project> _projects = new Set<Project>();
  Map<String, Timer> _timers = {};

  List<Project> get chronologically =>
      _projects.toList()
        ..sort((a, b) => b.key.compareTo(a.key));

  Set<Project> get projects => new Set<Project>.from(_projects);

  ProjectStore() {
    triggerOnAction(loadProjectAction, (project) {
      if (!_projectLoaded(project)) {
        _projects.add(project);
      }
    });

    loadMyProjectsAction.listen((_) => projectService.loadMyProjects());
    triggerOnAction(startTimerAction, _startCounter);
    triggerOnAction(stopTimerAction, _stopCounter);
    triggerOnAction(increaseCounterAction, (Project project) {
      project.counter++;
      projectService.update(project);
    });

    triggerOnAction(decreaseCounterAction, (Project project) {
      project.counter--;
      projectService.update(project);
    });

    triggerOnAction(resetCounterAction, (Project project) {
      project.counter = 0;
      projectService.update(project);
    });

    triggerOnAction(createProjectAction, (project) async {
      await projectService.insert(project);
      loadMyProjectsAction();
    });
  }

  bool _projectLoaded(Project project) {
    return _projects.map((p) => p.key).contains(project.key);
  }

  _startCounter(Project project) {
    print("Starting counter for $project");
    _stopCounter(project);
    _timers[project.key] = new Timer.periodic(const Duration(seconds: 1), (_) {
      project.timeSpent++;
      projectService.update(project);
      trigger();
    });
  }

  _stopCounter(Project project) {
    print("Stopping counter for $project");
    var oldTimer = _timers[project.key];
    if (oldTimer != null) {
      oldTimer.cancel();
    }
  }

  bool isCountingTime(Project project) {
    return _timers[project.key] != null && _timers[project.key].isActive;
  }
}
