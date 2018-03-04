import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GoogleSignIn googleSignIn = new GoogleSignIn();

class Auth {

  static final FirebaseAnalytics analytics = new FirebaseAnalytics();
  static final Auth _instance = new Auth._private();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  factory Auth() => _instance;

  FirebaseUser user;

  Auth._private(){
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      this.user = user;
      if (user != null) {
        analytics.setUserId(user.uid);
      }
    });
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

    final GoogleSignInAuthentication googleAuth = await currentUser
        .authentication;

    // Authenticate with firebase
    user = await firebaseAuth.signInWithGoogle(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

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
