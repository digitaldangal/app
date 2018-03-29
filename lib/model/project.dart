import 'package:crochet_land/model/base_firebase_entity.dart';

class Project extends BaseFirebaseEntity {

  String get title => getValue('title');

  set title(String title) {
    setValue('title', title);
  }

  String get imageUrl => getValue('imageUrl');

  set imageUrl(String imageUrl) => setValue('imageUrl', imageUrl);

  String get description => getValue('description') ?? '';

  set description(String description) => setValue('description', description);

  String get patternUrl => getValue('patternUrl');

  set patternUrl(String patternUrl) => setValue('patternUrl', patternUrl);

  int get timeSpent => getValue('timeSpent') ?? 0;

  set timeSpent(int timeSpent) => setValue('timeSpent', timeSpent);

  int get counter => getValue('counter') ?? 0;

  set counter(int counter) => setValue('counter', counter);

  get timestamp => getValue('timestamp');

  List<String> get suppliesKeys =>
      getValue('supplies')?.keys?.toList() ?? <String>[];

  void addSupply(String key) {
    if (getValue('supplies') == null) {
      setValue('supplies', <String, bool>{key: true});
    } else {
      getValue('supplies')[key] = true;
    }
  }

  Project.fromSnapshot(snapshot) : super.fromSnapshot(snapshot);

  Project.fromValues(Map<String, dynamic> values) : super.fromValues(values);

  Project();

}
