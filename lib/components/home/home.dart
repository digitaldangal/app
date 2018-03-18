import 'package:flutter/material.dart';

import '../drawer.dart';

class Home extends StatelessWidget {
  final AppBar appBar;
  final Widget body;

  Home({this.appBar, this.body});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar,
      body: body,
      drawer: new Drawer(
        child: new AppDrawer(),
      ),
    );
  }
}
