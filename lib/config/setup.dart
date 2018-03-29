import 'package:crochet_land/services/SupplyService.dart';
import 'package:crochet_land/services/auth.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:crochet_land/stores/project_store.dart';
import 'package:crochet_land/stores/user_store.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:service_registry/service_registry.dart';

import 'routes.dart';

setupApplication() {
  ServiceRegistry.registerService<Router>(Router, new Router());

  Routes.configureRoutes();

  ServiceRegistry.registerService<FirebaseAuth>(FirebaseAuth, FirebaseAuth.instance);
  ServiceRegistry.registerService<FirebaseAnalytics>(FirebaseAnalytics, new FirebaseAnalytics());
  ServiceRegistry.registerService<FirebaseDatabase>(
      FirebaseDatabase, FirebaseDatabase.instance..setPersistenceEnabled(true));

  var userStore = new UserStore();

  ServiceRegistry.registerService(UserStore, userStore);

  userStore.listen((store) {
    if ((store as UserStore).isLoggedIn) {
      ServiceRegistry.registerService<ProjectService>(ProjectService, new ProjectService());
      ServiceRegistry.registerService<ProjectStore>(ProjectStore, new ProjectStore());
      ServiceRegistry.registerService<SupplyRepository>(SupplyRepository, new SupplyRepository());
    }
  });

  var authenticationService = new AuthenticationService();

  ServiceRegistry.registerService<AuthenticationService>(
      AuthenticationService, authenticationService);
}
