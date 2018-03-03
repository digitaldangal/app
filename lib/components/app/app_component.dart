import 'package:crochet_land/components/projetcs/projects_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Crochet.land',
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Meus Projetos'),
          ),
          body: new ProjectsList(),
        ));
  }
}
