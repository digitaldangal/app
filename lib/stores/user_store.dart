import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flux/flutter_flux.dart';

class UserStore extends Store {
  static Action<FirebaseUser> updateUserAction = new Action<FirebaseUser>();
  FirebaseUser _user;

  FirebaseUser get user => _user;

  UserStore() {
    triggerOnAction(updateUserAction, (user) => _user = user);
  }

  bool get isLoggedIn => user != null;
}
