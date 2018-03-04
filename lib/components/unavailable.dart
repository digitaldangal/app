import 'package:flutter/material.dart';


notImplemented(context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    child: new AlertDialog(
      title: new Text('Ainda não disponível..'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('😢', style: Theme
                    .of(context)
                    .textTheme
                    .display3,),
              ],),
            new Text(
                'A gente sabe que é chato, mas o botão está aqui pra você saber no que estamos trabalhando OK?', textAlign: TextAlign.center,),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('👍 Tudo bem'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}