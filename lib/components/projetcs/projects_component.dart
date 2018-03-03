import 'package:crochet_land/components/projetcs/counter_component.dart';
import 'package:crochet_land/components/projetcs/material_list_component.dart';
import 'package:crochet_land/components/projetcs/photos_component.dart';
import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

final FirebaseAnalytics analytics = new FirebaseAnalytics();

class ProjectsList extends StatefulWidget {
  @override
  _ProjectsListState createState() => new _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  List<Project> _projects = [];

  _ProjectsListState() {
    analytics.logViewItemList(itemCategory: 'projects');
    loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
      new _ProjectListItem(_projects[index]),
      itemCount: _projects.length,
    );
  }

  loadProjects() async {
    var projects = await ProjectService.getMyProjects();
    setState(() {
      this._projects = projects;
    });
  }
}

class _ProjectListItem extends StatelessWidget {


  final Project _project;

  _ProjectListItem(this._project);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(_project.title[0]),
      ),
      title: new Text(_project.title),
      subtitle: new Text(_project.description),
      trailing: new Icon(Icons.navigate_next),
      onTap: () {
        analytics.logViewItem(itemId: _project.key,
            itemName: _project.title,
            itemCategory: 'projects');
        Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new ProjectWidget(_project);
          },
        ));
      },
    );
  }
}

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
            analytics.logViewItem(itemId: _project.key + '-pattern',
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
                            analytics.logShare(contentType: 'pattern-url',
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
    var tabs = <Tab>[];
    tabs.addAll([
      new Tab(text: 'contador'),
      new Tab(text: 'material'),
    ]);
    return tabs;
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
