import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/unavailable.dart';
import '../routes.dart';
import '../services/auth.dart';


class AppDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AppDrawerState();
  }

}


class _AppDrawerState extends State<AppDrawer> {
  static final auth = new Auth();

  FirebaseUser _user;


  @override
  void initState() {
    _user = auth.user;
    super.initState();
  }

  get avatar =>
      _user != null ? _user.photoUrl : 'http://i.pravatar.cc/300?id=a';


  get email =>
      _user != null ? _user.email : 'email@crochet.land';

  get name => _user != null ? _user.displayName : 'Crochet.Land';

  @override
  Widget build(BuildContext context) {
    final theme = Theme
        .of(context);
    return new Column(children: <Widget>[
      new UserAccountsDrawerHeader(
          accountName: new Text(
              name, style: new TextStyle(color: Colors.white)),
          accountEmail: new Text(
              email, style: new TextStyle(color: Colors.white)),
          currentAccountPicture: new CircleAvatar(
            backgroundImage: new NetworkImage(avatar),
            radius: 50.0,
          ),
          decoration: new BoxDecoration(
              color: theme.primaryColor,
              image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.6), BlendMode.dstATop),
                image: new NetworkImage(
                    'https://source.unsplash.com/featured/?yarn,crochet'),
                fit: BoxFit.cover,)
          )
      ),
      new ListTile(
        leading: new Icon(Icons.assignment,),
        title: new Text('Meus Projetos'),
        trailing: new Icon(Icons.navigate_next),
        onTap: () =>
            Navigator.of(context).pushReplacementNamed(Routes.projects),
      ),
      new ListTile(
        leading: new Icon(Icons.dashboard,),
        title: new Text('Minhas coisinhas'),
        trailing: new Icon(Icons.navigate_next),
        onTap: () {
          notImplemented(context);
        },
      ),
      new Divider(height: 20.0, color: theme.primaryColor,),
      new ListTile(
        leading: new Icon(Icons.account_circle,),
        title: new Text('Minha Conta'),
        trailing: new Icon(Icons.navigate_next),
        onTap: () {
          notImplemented(context);
        },
      ),
      new Expanded(child:
      new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new ListTile(
            trailing: new Icon(Icons.power_settings_new),
            title: new Text('Sair'),
            onTap: () {
              auth.signout();
              Navigator.of(context).pushReplacementNamed(Routes.login);
            },
          )
        ],
      ))
    ],);
  }

}