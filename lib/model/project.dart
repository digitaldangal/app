import 'package:firebase_database/firebase_database.dart';

class Project {
  String key;

  Map<String, dynamic> _values;

  String get title => _values['title'];

  set title(String title) {
    _values['title'] = title;
  }

  String get imageUrl => _values['imageUrl'];

  set imageUrl(String imageUrl) {
    _values['imageUrl'] = imageUrl;
  }

  String get description => _values['description'] ?? '';

  set description(String description) {
    _values['description'] = description;
  }

  String get patternUrl => _values['patternUrl'];

  set patternUrl(String patternUrl) {
    _values['patternUrl'] = patternUrl;
  }

  int get timeSpent => _values['timeSpent'] ?? 0;

  set timeSpent(int timeSpent) {
    _values['timeSpent'] = timeSpent;
  }

  int get counter => _values['counter'] ?? 0;

  set counter(int counter) {
    _values['counter'] = counter;
  }

  get timestamp => _values['timestamp'];

  List<String> get supplies => _values['supplies'].map((key, _) => key);

  void addSupply(String key) => _values['supplies'][key] = true;

  @override
  String toString() {
    return 'Project{key: $key, title: $title}';
  }


  Project() {
    _values = new Map<String, dynamic>();
  }


  Project.fromSnapshot(DataSnapshot snapshot)
      : _values = snapshot.value,
        key = snapshot.key;

  toMap() {
    _values['timestamp'] ??= ServerValue.timestamp;
    return _values;
  }


}
