class Novel {
  final String title;
  final String imgSrc;
  final String baseURL;

  Novel(this.title, this.imgSrc, this.baseURL);

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(json['title'] as String, json['imgSrc'] as String,
        json['baseURL'] as String);
  }
}
