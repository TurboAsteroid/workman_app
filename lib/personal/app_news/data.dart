class AppNewsData {
  String newsLink;
  List<ImageObj> images;

  AppNewsData({this.newsLink, this.images});

  AppNewsData.fromJson(Map<String, dynamic> json) {
    newsLink = json['news_link'];
    if (json['images'] != null) {
      images = new List<ImageObj>();
      json['images'].forEach((v) {
        images.add(new ImageObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['news_link'] = this.newsLink;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageObj {
  String description;
  String url;
  String thumbUrl;

  ImageObj({this.description, this.url, this.thumbUrl});

  ImageObj.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    url = json['url'];
    thumbUrl = json['thumbUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['url'] = this.url;
    data['thumbUrl'] = this.thumbUrl;
    return data;
  }
}

class NewsInListData {
  int id;
  String title;
  String description;
  String timeCreated;
  String appNewsUrl;
  String appNewsImage;

  NewsInListData(
      {this.id,
      this.title,
      this.description,
      this.timeCreated,
      this.appNewsUrl,
      this.appNewsImage});

  NewsInListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    timeCreated = json['time_created'].toString();
    appNewsUrl = json['appNewsUrl'].toString();
    appNewsImage = json['appNewsImage'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['time_created'] = this.timeCreated;
    data['appNewsUrl'] = this.appNewsUrl;
    data['appNewsImage'] = this.appNewsImage;
    return data;
  }
}
