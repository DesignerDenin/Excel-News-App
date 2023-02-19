class News {
  int? id;
  String title = "";
  String content = "";
  String imageURL = "";
  String link = "";
  String date = "";

  News({
    int? id,
    String? title,
    String? content,
    String? imageURL,
    String? link,
    String? date
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'link': link,
    };
  }

  News.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    content = map['content'];
    imageURL = map['imageurl'];
    link = map['link'];
    date = map['date'];
  }
}