import 'dart:async';

import 'package:crochet_land/config/routes.dart';
import 'package:crochet_land/stores/user_store.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:service_registry/service_registry.dart';

import '../../services/auth.dart';

class Login extends StatefulWidget {
  final AuthenticationService auth = ServiceRegistry.getService(AuthenticationService);

  @override
  State createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription _authListener;

  bool _signingIn = true;

  @override
  void initState() {
    super.initState();
    _authListener = ServiceRegistry.getService<UserStore>(UserStore).listen((store) {
      var user = (store as UserStore).user;
      if (user != null) {
        debugPrint('Authenticated as ${user.email}');
        _goToHome();
      } else {
        debugPrint('Unauthenticated :-(');
        setState(() {
          debugPrint('_signinIn = false');
          _signingIn = false;
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
    new Future.microtask(() {
      ServiceRegistry.getService<Router>(Router).navigateTo(context, Routes.home, replace: true);
    });
  }

  _signInWithGoogle() async {
    setState(() {
      this._signingIn = true;
    });
    await widget.auth.signInWithGoogle().then((user) {
      debugPrint('Authenticated! :-) $user');
    }).catchError((err) {
      debugPrint('Error signin in with google $err');
    });
    setState(() {
      this._signingIn = false;
    });
  }

  _signInWithFacebook() async {
    setState(() {
      this._signingIn = true;
    });
    await widget.auth.signInWithFacebook().then((user) {
      debugPrint('Authenticated! :-) $user');
    });
    setState(() {
      this._signingIn = false;
    });
  }

  _loadingWidgets() {
    return <Widget>[
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new CircularProgressIndicator(),
          new SizedBox(width: 20.0),
          new Text("Carregando..."),
        ],
      ),
    ];
  }

  _signInButtons() {
    debugPrint('_signinButtons()');
    return <Widget>[
      new Text(
        'Faça login para poder salvar seus dados e recuperar a qualquer momento',
        textAlign: TextAlign.center,
      ),
      new RaisedButton.icon(
          onPressed: _signInWithGoogle,
          icon: new Icon(
            Icons.account_circle,
            color: Colors.red,
          ),
          label: new Text("Login com Google"),
          color: Colors.white),
      new RaisedButton.icon(
        onPressed: () => _signInWithFacebook(),
        icon: new Icon(
          Icons.face,
          color: Colors.white,
        ),
        label: new Text(
          "Login com Facebook",
          style: new TextStyle(color: Colors.white),
        ),
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
        body: new Padding(
            padding: new EdgeInsets.all(20.0),
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _signingIn ? _loadingWidgets() : _signInButtons()))));
  }
}
