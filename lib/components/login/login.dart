import 'dart:async';

import 'package:crochet_land/routes.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';


class Login extends StatefulWidget {
  @override
  State createState() => new _SplashScreenState();
}

class _SplashScreenState extends State {

  bool _signinIn = true;

  @override
  void initState() {
    super.initState();

    auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        debugPrint('Authenticated as ${user.email}');
        _goToHome();
      } else {
        debugPrint('Unauthenticated :-(');
        setState(() {
          _signinIn = false;
        });
      }
    });
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
      debugPrint('Authenticated! :-) $user');
    });
  }

  _signinWithFacebook() async {
    await _neverSatisfied();
  }

  Future<Null> _neverSatisfied() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      child: new AlertDialog(
        title: new Text('Ainda não disponível..'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('A gente sabe que é chato.'),
              new Text(
                  'Mas o botão está aqui pra você saber que logo estará disponível OK?'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Tudo bem'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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