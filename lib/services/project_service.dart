import '../model/project.dart';

class ProjectService {
  static getMyProjects() async {
    return <Project>[
      new Project(
          key: 'Descolado 1',
          title: 'Descolado 1',
          description: 'Algo de girafa mesmo',
          timeSpent: 59,
          patternUrl: "https://crochet.land/tiara-de-girafa-desafiodescolado-descolandogirafas/"),
      new Project(
          key: 'Test project 2',
          title: 'Super descolado 2',
          description: 'Algo ainda mais incrível de girafa',
          timeSpent: 119)
    ];
  }
}
