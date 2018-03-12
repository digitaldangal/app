import 'package:crochet_land/components/blog_post_card.dart';
import 'package:crochet_land/services/wordpress_post_service.dart';
import 'package:flutter/material.dart';

class BlogPostList extends StatefulWidget {
  @override
  _BlogPostListState createState() => new _BlogPostListState();
}

class _BlogPostListState extends State<BlogPostList> {
  List<Map<String, dynamic>> _posts = [];

  _BlogPostListState();


  @override
  void initState() async {
    var posts = await new WordpressPostService().loadPostsFromApi();
    setState(() {
      this._posts = posts.toList();
    });
  }


  Widget _buildBody(BuildContext context) {
    if (_posts.isEmpty) {
      return new Center(child: new CircularProgressIndicator());
    }
    return new AnimatedList(itemBuilder: (context, index, animation) {
      var post = _posts[index];
      return new BlogPostCard(
          post['link'], post['featured_media'], post['title']['rendered'],
          post['summary']['rendered']);
    }, initialItemCount: _posts.length);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: _buildBody(context),
      appBar: new AppBar(title: new Text("Novidades"),),);
  }
}


