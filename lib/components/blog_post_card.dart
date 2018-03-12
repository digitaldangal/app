import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogPostCard extends StatelessWidget {

  String _url;
  String _imageUrl;
  String _summary;
  String _title;


  BlogPostCard(this._url, this._imageUrl, this._title, this._summary);

  @override
  Widget build(BuildContext context) {
    var headLine = Theme
        .of(context)
        .textTheme
        .headline
        .copyWith(color: Colors.white);
    return
      new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Card(child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Container(
                margin: new EdgeInsets.symmetric(vertical: 10.0),
                height: 150.0,
                alignment: Alignment.bottomRight,
                decoration: new BoxDecoration(image: new DecorationImage(
                  image: new NetworkImage(_imageUrl),
                  fit: BoxFit.cover,)),
                child: new Text(
                  _title, textAlign: TextAlign.center, style: headLine,),
              ),
              subtitle: new Text(_summary.replaceAll(new RegExp('<[^>]*>'), ''),
                textAlign: TextAlign.justify,),
            ),


            new ButtonTheme
                .bar( //make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[

                  new FlatButton(
                    child: const Text('VER MAIS'),
                    onPressed: () {
                      launch(_url);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      )
    ;
  }
}
