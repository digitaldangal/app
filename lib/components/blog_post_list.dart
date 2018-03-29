import 'package:crochet_land/components/blog_post_card.dart';
import 'package:crochet_land/services/wordpress_post_service.dart';
import 'package:flutter/material.dart';

class BlogPostList extends StatefulWidget {
  @override
  _BlogPostListState createState() => new _BlogPostListState();
}

class _BlogPostListState extends State<BlogPostList> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey = new GlobalKey<RefreshIndicatorState>();

  List<Map<String, dynamic>> _posts = [];

  final durationBase = const Duration(milliseconds: 500);

  _BlogPostListState();

  @override
  void initState() async {
    _refreshKey.currentState.show();
    super.initState();
  }

  _loadBlogPosts() async {
    Iterable<Map<String, dynamic>> posts = await new WordpressPostService().loadPostsFromApi();
    _posts.clear();
    posts.forEach((post) {
      setState(() {
        var index = this._posts.length;
        this._posts.add(post);
        this._listKey.currentState.insertItem(index,
            duration: new Duration(seconds: durationBase.inSeconds, milliseconds: 500 * index));
      });
    });
  }

  Widget _buildBody(BuildContext context) {
    return new RefreshIndicator(
        key: _refreshKey,
        onRefresh: _loadBlogPosts,
        child: new AnimatedList(
            key: _listKey,
            itemBuilder: (context, index, animation) {
              var post = _posts[index];
              return new FadeTransition(
                  opacity: animation,
                  child: new BlogPostCard(
                    post['link'],
                    post['featured_media'],
                    post['title']['rendered'],
                    post['summary']['rendered'],
                  ));
            },
            initialItemCount: _posts.length));
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
