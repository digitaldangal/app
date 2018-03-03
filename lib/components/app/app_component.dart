import 'dart:async';

import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../config/theme.dart';

final googleSignIn = new GoogleSignIn();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Crochet.land',
        theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme,
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Meus Projetos'),
          ),
          body: new ProjectsList(),
        ));
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
    }
  }

  watchGoogleUserChange() {
    googleSignIn.onCurrentUserChanged.listen((account) {
      print('Google account changed');
      print(account);
      //TODO change the user store
      print('Photo Url: ${account.photoUrl}');
    });
  }

  MyApp() {
    watchGoogleUserChange();
    _ensureLoggedIn();
  }
}
