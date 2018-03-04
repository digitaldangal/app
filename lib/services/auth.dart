import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = new GoogleSignIn();

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

  final GoogleSignInAuthentication googleAuth = await currentUser.authentication;

  // Authenticate with firebase
  final FirebaseUser user = await auth.signInWithGoogle(
    idToken: googleAuth.idToken,
    accessToken: googleAuth.accessToken,
  );

  assert(user != null);
  assert(!user.isAnonymous);

  return user;
}

Future signout() async {
  // Sign out with firebase
  await auth.signOut();
  // Sign out with google
  await googleSignIn.signOut();
}