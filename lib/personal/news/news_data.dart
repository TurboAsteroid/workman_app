class News {
  Response response;

  News({this.response});

  News.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  List<NewsItem> newsItems;

  Response({this.count, this.newsItems});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      newsItems = new List<NewsItem>();
      json['items'].forEach((v) {
        newsItems.add(new NewsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.newsItems != null) {
      data['items'] = this.newsItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewsItem {
  int id;
  int fromId;
  int ownerId;
  int date;
  int markedAsAds;
  String postType;
  String text;
  List<Attachments> attachments;
  Comments comments;
  Likes likes;
  Reposts reposts;
  Views views;

  NewsItem(
      {this.id,
        this.fromId,
        this.ownerId,
        this.date,
        this.markedAsAds,
        this.postType,
        this.text,
        this.attachments,
        this.comments,
        this.likes,
        this.reposts,
        this.views});

  NewsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromId = json['from_id'];
    ownerId = json['owner_id'];
    date = json['date'];
    markedAsAds = json['marked_as_ads'];
    postType = json['post_type'];
    text = json['text'];
    if (json['attachments'] != null) {
      attachments = new List<Attachments>();
      json['attachments'].forEach((v) {
        attachments.add(new Attachments.fromJson(v));
      });
    }
    comments = json['comments'] != null
        ? new Comments.fromJson(json['comments'])
        : null;
    likes = json['likes'] != null ? new Likes.fromJson(json['likes']) : null;
    reposts =
    json['reposts'] != null ? new Reposts.fromJson(json['reposts']) : null;
    views = json['views'] != null ? new Views.fromJson(json['views']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_id'] = this.fromId;
    data['owner_id'] = this.ownerId;
    data['date'] = this.date;
    data['marked_as_ads'] = this.markedAsAds;
    data['post_type'] = this.postType;
    data['text'] = this.text;
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.toJson();
    }
    if (this.likes != null) {
      data['likes'] = this.likes.toJson();
    }
    if (this.reposts != null) {
      data['reposts'] = this.reposts.toJson();
    }
    if (this.views != null) {
      data['views'] = this.views.toJson();
    }
    return data;
  }
}

class Attachments {
  String type;
  Photo photo;

  Attachments({this.type, this.photo});

  Attachments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    return data;
  }
}

class Photo {
  int id;
  int albumId;
  int ownerId;
  int userId;
  List<Sizes> sizes;
  String text;
  int date;
  int postId;
  String accessKey;

  Photo(
      {this.id,
        this.albumId,
        this.ownerId,
        this.userId,
        this.sizes,
        this.text,
        this.date,
        this.postId,
        this.accessKey});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumId = json['album_id'];
    ownerId = json['owner_id'];
    userId = json['user_id'];
    if (json['sizes'] != null) {
      sizes = new List<Sizes>();
      json['sizes'].forEach((v) {
        sizes.add(new Sizes.fromJson(v));
      });
    }
    text = json['text'];
    date = json['date'];
    postId = json['post_id'];
    accessKey = json['access_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['album_id'] = this.albumId;
    data['owner_id'] = this.ownerId;
    data['user_id'] = this.userId;
    if (this.sizes != null) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    data['text'] = this.text;
    data['date'] = this.date;
    data['post_id'] = this.postId;
    data['access_key'] = this.accessKey;
    return data;
  }
}

class Sizes {
  String type;
  String url;
  int width;
  int height;

  Sizes({this.type, this.url, this.width, this.height});

  Sizes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Comments {
  int count;

  Comments({this.count});

  Comments.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}

class Likes {
  int count;

  Likes({this.count});

  Likes.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}

class Reposts {
  int count;

  Reposts({this.count});

  Reposts.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}

class Views {
  int count;

  Views({this.count});

  Views.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}