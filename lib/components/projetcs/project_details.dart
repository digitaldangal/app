import 'package:crochet_land/components/projetcs/counter_component.dart';
import 'package:crochet_land/components/projetcs/material_list_component.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/analytics.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';


class ProjectWidget extends StatefulWidget {

  Project _project;

  ProjectWidget(this._project);

  @override
  State<StatefulWidget> createState() {
    return new _ProjectWidgetState(_project);
  }


}

class _ProjectWidgetState extends State<ProjectWidget> {
  Project _project;
  String _webViewUrl;

  _ProjectWidgetState(this._project);


  @override
  void dispose() {
    new ProjectService().update(_project);
    super.dispose();
  }

  _buildActionbarActions(BuildContext context) {
    if (_project.patternUrl == null) {
      return null;
    }
    _webViewUrl = _project.patternUrl;
    var flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged
        .listen((url) => this.setState(() => _project.patternUrl = url));

    return <Widget>[
      new IconButton(
          icon: new Icon(Icons.open_in_new),
          onPressed: () {
            AnalyticsService.analytics.logViewItem(
                itemId: _project.key + '-pattern',
                itemName: _project.title,
                itemCategory: 'project-patterns');
            //TODO there's an error that the url is being saved if the user navigates away from the pattern url
            Navigator.of(context).push(new MaterialPageRoute<Null>(
              maintainState: false,
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return new WebviewScaffold(
                  url: _project.patternUrl,
                  appBar: new AppBar(
                    title: new Text("Padrão"),
                    actions: <Widget>[
                      new IconButton(
                          icon: new Icon(Icons.share),
                          onPressed: () {
                            AnalyticsService.analytics.logShare(
                                contentType: 'pattern-url',
                                itemId: _project.key);
                            share(_webViewUrl);
                          })
                    ],
                  ),
                );
              },
            ));
          })
    ];
  }

  _buildSilverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      new SliverAppBar(
        actions: _buildActionbarActions(context),
        title: new Text(_project.title),
        forceElevated: innerBoxIsScrolled,
        pinned: true,
        floating: true,
        bottom: new TabBar(
          tabs: _buildTabs(),
        ),
      ),
    ];
  }

  List<Tab> _buildTabs() {
    return <Tab>[
      new Tab(text: 'contador'),
      new Tab(text: 'material'),
    ];
  }

  TabBarView _buildTabBarView() {
    return new TabBarView(
      children: <Widget>[
        new CounterComponent(_project),
        new ProjectMaterials(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_project == null) {
      return new Scaffold(
        body: new Center(child: new CircularProgressIndicator(),),);
    }
    var tabView = _buildTabBarView();
    return new DefaultTabController(
      length: tabView.children.length,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return _buildSilverAppBar(context, innerBoxIsScrolled);
          },
          body: tabView,
        ),
      ),
    );
  }
}
