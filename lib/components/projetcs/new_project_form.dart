import 'package:crochet_land/model/project.dart';
import 'package:crochet_land/services/project_service.dart';
import 'package:flutter/material.dart';
import 'package:validator/validator.dart';

class NewProjectForm extends StatefulWidget {
  static ProjectService projectService = new ProjectService();

  @override
  State<StatefulWidget> createState() {
    return new _NewProjectFormState();
  }
}

class _NewProjectFormState extends State<NewProjectForm> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Project _project;
  bool _saving = false;

  @override
  void initState() {
    _project = new Project();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Novo projeto'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.check),
            onPressed: () async {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                setState(() {
                  _saving = true;
                });
                await NewProjectForm.projectService.insert(_project);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              _saving ? new LinearProgressIndicator() : new Container(),
              new ListTile(
                leading: new Icon(Icons.title),
                title: new TextFormField(
                  focusNode: _saving ? new AlwaysDisabledFocusNode() : null,
                  autofocus: true,
                  maxLines: 2,
                  decoration: new InputDecoration(labelText: 'Nome do projeto'),
                  validator: (val) {
                    return !isLength(val, 3) ? 'Escreve algo vai...' : null;
                  },
                  onSaved: (val) => _project.title = val.length > 0 ? val : null,
                ),
              ),
              new ListTile(
                leading: new Icon(Icons.description),
                title: new TextFormField(
                  focusNode: _saving ? new AlwaysDisabledFocusNode() : null,
                  maxLines: 3,
                  decoration: new InputDecoration(labelText: 'Descrição básica'),
                  onSaved: (val) => _project.description = val.length > 0 ? val : null,
                ),
              ),
// TODO find a better way to show the pattern
//              new ListTile(
//                leading: new Icon(Icons.link),
//                title: new TextFormField(
//                  focusNode: _saving ? new AlwaysDisabledFocusNode() : null,
//                  maxLines: 2,
//                  validator: (val) => !isNull(val) && !isURL(val) ? 'Não é um link :-(' : null,
//                  decoration: new InputDecoration(labelText: 'Link pro pattern'),
//                  onSaved: (val) => _project.patternUrl = val.length > 0 ? val : null,
//                ),
//              ),
            ],
          )),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
