import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:crochet_land/stores/project_store.dart';
import 'package:mockito/mockito.dart';
import 'package:service_registry/service_registry.dart';
import 'package:test/test.dart';

import 'mocks.dart';

void main() {
  ProjectStore store;
  setUp(() {
    ServiceRegistry.registerService(ProjectService, new MockProjectService());
    store = new ProjectStore();
  });

  test("Should load project", () async {
    expect(store.projects, isEmpty);

    await ProjectStore.loadProjectAction(new Project());

    expect(store.projects, isNotEmpty);
  });

  test("Should load projects", () async {
    expect(store.projects, isEmpty);

    await ProjectStore.loadMyProjectsAction();

    verify(ProjectStore.projectService.loadMyProjects()).called(greaterThan(0));
  });
}
