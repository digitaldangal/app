class Project {
  String key;
  String title;
  String imageUrl;
  String description;
  String patternUrl;
  int timeSpent;
  int counter;

  Project(
      {this.key, this.title, this.imageUrl, this.description, this.timeSpent, this.counter = 0, this.patternUrl});

  @override
  String toString() {
    return 'Project{key: $key, title: $title, imageUrl: $imageUrl, description: $description, patternUrl: $patternUrl, timeSpent: $timeSpent, counter: $counter}';
  }


}
