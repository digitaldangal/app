import 'package:crochet_land/components/home/home.dart';
import 'package:crochet_land/components/login/login.dart';
import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';


final router = new Router();

var projectsRouteHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new Home();
    });

var loginRouteHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new Login();
    });

var projectsViewRouteHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      var key = params['key'];
      return new ProjectWidget(key);
    });

class Routes {

  static String login = '/';
  static String home = '/home';
  static String projects = home;

  static void configureRoutes(Router router) {
    router.define(login, handler: loginRouteHandler);
    router.define(home, handler: projectsRouteHandler);
  }

}

