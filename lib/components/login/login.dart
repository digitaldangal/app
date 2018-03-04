import 'dart:async';

import '../../routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../services/auth.dart';
import '../../components/unavailable.dart';

final analytics = new FirebaseAnalytics();

class Login extends StatefulWidget {
  @override
  State createState() => new _SplashScreenState();
}

class _SplashScreenState extends State {
  StreamSubscription _authListener;

  bool _signinIn = true;

  @override
  void initState() {
    super.initState();
    _authListener = auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        debugPrint('Authenticated as ${user.email}');
        analytics.setUserId(user.uid);
        _goToHome();
      } else {
        debugPrint('Unauthenticated :-(');
        setState(() {
          _signinIn = false;
        });
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    _authListener.cancel();
  }

  _goToHome() {
    new Future.delayed(new Duration(milliseconds: 1), () {
      Navigator.of(context).pushReplacementNamed(ROUTE_HOME);
    });
  }


  _signinWithGoogle() {
    setState
      (() {
      this._signinIn = true;
    });
    signInWithGoogle().then((user) {
      analytics.logLogin();
      debugPrint('Authenticated! :-) $user');
    });
  }

  _signinWithFacebook() async {
    //TODO analytics.logLogin();
    await notImplemented(context);
  }

  _loadingWidgets() {
    return <Widget>[
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new CircularProgressIndicator(),
          new SizedBox(width: 20.0),
          new Text("Esperany..."),
        ],
      ),
    ];
  }

  _signinButtons() {
    return <Widget>[

      new Text(
        'Faça login para poder salvar seus dados e recuperar a qualquer momento',
        textAlign: TextAlign.center,
      )
      ,
      new RaisedButton.icon(onPressed: _signinWithGoogle,
          icon: new Icon(Icons.account_circle, color: Colors.red,),
          label: new Text("Login com Google"),
          color: Colors.white),
      new RaisedButton.icon(onPressed: () => _signinWithFacebook(),
        icon: new Icon(Icons.face, color: Colors.white,),
        label: new Text(
          "Login com Facebook", style: new TextStyle(color: Colors.white),),
        color: new Color.fromRGBO(59, 89, 152, 1.0),

      ),
      new Text(
        'Ainda estamos terminando de escrever nossos Termos de Serviço, mas garantimos que não vai rolar coisa do mal.',
        textAlign: TextAlign.center,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Padding(padding: new EdgeInsets.all(20.0),
            child: new Center(child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _signinIn ? _loadingWidgets() : _signinButtons()
            ))
        )
    );
  }
}