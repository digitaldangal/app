class Project {
  String key;
  String title;
  String description;
  int timeSpent;
  int counter;
  String patternUrl;

  Project(
      {this.key, this.title, this.description, this.timeSpent, this.counter = 0, this.patternUrl});
}
