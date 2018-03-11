import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GoogleSignIn googleSignIn = new GoogleSignIn();

class Auth {

  static final FirebaseAnalytics analytics = new FirebaseAnalytics();
  static final Auth _instance = new Auth._private();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  factory Auth() => _instance;

  FirebaseUser user;

  Auth._private(){
    firebaseAuth.onAuthStateChanged.listen((user) {
      this.user = user;
      if (user != null) {
        analytics.setUserId(user.uid);
      }
    });
  }

  Future signInWithFacebook() async {
    var facebookLogin = new FacebookLogin();
    FacebookLoginResult result =
    await facebookLogin.logInWithReadPermissions(['email']);
    var user;
    var accessToken;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        accessToken = result.accessToken.token;
        break;
      case FacebookLoginStatus.cancelledByUser:
      case FacebookLoginStatus.error:
      // TODO show something to the user?
      //_showErrorOnUI(result.errorMessage);
    }

    try {
      user = await firebaseAuth.signInWithFacebook(accessToken: accessToken);
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        print(e.code);
        print(e.details);
      }
    }
    return _onLogin(user);
  }


  Future signInWithGoogle() async {
    // Attempt to get the currently authenticated user
    GoogleSignInAccount currentUser = googleSignIn.currentUser;
    if (currentUser == null) {
      // Attempt to sign in without user interaction
      currentUser = await googleSignIn.signInSilently();
    }
    if (currentUser == null) {
      // Force the user to interactively sign in
      currentUser = await googleSignIn.signIn();
    }
    if (googleSignIn.currentUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await currentUser
        .authentication;

    // Authenticate with firebase
    user = await firebaseAuth.signInWithGoogle(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    return _onLogin(user);
  }

  _onLogin(user) {
    assert(user != null);
    assert(!user.isAnonymous);
    analytics.logLogin();
    return user;
  }

  Future signout() async {
    // Sign out with firebase
    await firebaseAuth.signOut();
    // Sign out with google
    await googleSignIn.signOut();
  }


}
