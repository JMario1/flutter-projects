
import 'package:flutter/foundation.dart';


class Post {
  String text;
  DateTime time;
  String id;
  int likes;
  String imageUrl;
  User user;
  List<Comments> comments;

  Post(
      {this.text,
      this.time,
      this.id,
      this.likes,
      this.imageUrl,
      this.user,
      this.comments});

  Post.fromMap(Map<String, dynamic> map) {
    text = map['text'];
    time = DateTime.fromMicrosecondsSinceEpoch(map['time'], isUtc: true) ;
    id = map['id'];
    likes = map['likes'];
    imageUrl = map['imageUrl'];
    user = map['user'] != null ? new User.fromMap(map['user']) : null;
    if (map['comments'] != null) {
      comments = new List<Comments>();
      map['comments'].forEach((v) {
        comments.add(new Comments.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['time'] = this.time.toUtc().microsecondsSinceEpoch;
    data['id'] = this.id;
    data['likes'] = this.likes;
    data['imageUrl'] = this.imageUrl;
    if (this.user != null) {
      data['user'] = this.user.toMap();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

class User {
  String uid;
  String name;
  String avatarUrl;

  User({@required this.uid, this.name, this.avatarUrl});

  User.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    avatarUrl = map['avatarUrl'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['avatarUrl'] = this.avatarUrl;
    return data;
  }
}

class Comments {
  User user;
  String text;
  DateTime time;

  Comments({this.user, this.text, this.time});

  Comments.fromMap(Map<String, dynamic> map) {
    user = map['user'] != null ? new User.fromMap(map['user']) : null;
    text = map['text'];
    time = DateTime.fromMicrosecondsSinceEpoch(map['time'], isUtc: true) ;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toMap();
    }
    data['text'] = this.text;
    data['time'] = this.time.toUtc().microsecondsSinceEpoch;
    return data;
  }
}
