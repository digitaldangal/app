import 'package:crochet_land/components/home/home.dart';
import 'package:crochet_land/components/login/login.dart';
import 'package:crochet_land/components/projetcs/new_project_form.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';


var projectsRouteHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new Home();
    });

var loginRouteHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new Login();
    });

//var projectsViewRouteHandler = new Handler(
//    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
//      var key = params['key'];
//      return new ProjectWidget(key);
//    });

var newProjectRouteHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new NewProjectForm();
    });

class Routes {

  static final router = new Router();

  static String login = '/';
  static String home = '/home';
  static String projects = home;
  static String newProject = '/projects/new';

  static void configureRoutes(Router router) {
    router.define(login, handler: loginRouteHandler);
    router.define(home, handler: projectsRouteHandler);
    router.define(newProject, handler: newProjectRouteHandler);
  }

}

