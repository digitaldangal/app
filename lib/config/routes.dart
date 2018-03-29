import 'package:crochet_land/components/blog_post_list.dart';
import 'package:crochet_land/components/home/home.dart';
import 'package:crochet_land/components/login/login.dart';
import 'package:crochet_land/components/projetcs/new_project_form.dart';
import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:service_registry/service_registry.dart';

var projectsRouteHandler =
new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new Home(
    body: new ProjectsList(),
    appBar: new AppBar(
      title: new Text('Meus Projetos'),
    ),
  );
});

var loginRouteHandler =
new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new Login();
});

//var projectsViewRouteHandler = new Handler(
//    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//      var key = params['key'];
//      return new ProjectWidget(key);
//    });

var newProjectRouteHandler =
new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new NewProjectForm();
});

var newsRouteHandler =
new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new Home(
    body: new BlogPostList(),
    appBar: new AppBar(
      title: new Text('Bacanices'),
    ),
  );
});

class Routes {
  static final router = ServiceRegistry.getService<Router>(Router);

  static String login = '/';
  static String home = '/home';
  static String projects = home;
  static String newProject = '/projects/new';
  static String news = '/news';

  static void configureRoutes() {
    router.define(login, handler: loginRouteHandler);
    router.define(
      home,
      handler: projectsRouteHandler,
    );
    router.define(newProject, handler: newProjectRouteHandler);
    router.define(news, handler: newsRouteHandler);
  }
}
