import 'dart:async';
import 'dart:convert';
import 'dart:io';

class WordpressPostService {

  static const String DOMAIN = 'crochet.land';

  static final WordpressPostService _instance = new WordpressPostService
      ._private();

  factory WordpressPostService() => _instance;

  WordpressPostService._private();

  _uriToJson(uri) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    return await JSON.decode(await response.transform(UTF8.decoder).join());
  }

  loadPostsFromApi({int page: 1}) async {
    var uri = new Uri.https(
        DOMAIN,
        '/wp-json/wp/v2/posts',
        {'page': page.toString()}
    );

    List<Map<String, dynamic>> posts = await _uriToJson(uri);


    return Future.wait(posts.map((post) async =>
    {
      'id': post['id'],
      'title': post['title'],
      'link': post['link'],
      'featured_media': await _getMediaUrl(post['featured_media']),
      'summary': post['excerpt'],
    }));
  }

  _getMediaUrl(int id) async {
    var uri = new Uri.https(
        DOMAIN,
        '/wp-json/wp/v2/media/$id'
    );

    Map<String, dynamic> media = await _uriToJson(uri);

    return media['source_url'];
  }

}