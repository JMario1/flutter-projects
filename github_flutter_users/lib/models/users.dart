class Users {
  List<Item> items;

  Users({this.items});

  Users.fromJson(List<dynamic> json) {
    if (json != null) {
      items = new List<Item>();
      json.forEach((v) {
        items.add(Item.fromJson(v));
      });
    }
  }

  List<Item> toJson() {
     List<Item> data = new List<Item>();
    if (this.items != null) {
      data = this.items;
    }
    return data;
  }
}

class Item {
  String url;
  String htmlUrl;

  Item({this.url, this.htmlUrl});

  Item.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    htmlUrl = json['html_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['html_url'] = this.htmlUrl;
    return data;
  }
}



class User {
  String login;
  int id;
  String avatarUrl;
  String url;
  String htmlUrl;
  String type;
  String name;
  String location;

  User(
      {this.login,
      this.id,
      this.avatarUrl,
      this.url,
      this.htmlUrl,
      this.type,
      this.name,
      this.location});

  User.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    avatarUrl = json['avatar_url'];
    url = json['url'];
    htmlUrl = json['html_url'];
    type = json['type'];
    name = json['name'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['id'] = this.id;
    data['avatar_url'] = this.avatarUrl;
    data['url'] = this.url;
    data['html_url'] = this.htmlUrl;
    data['type'] = this.type;
    data['name'] = this.name;
    data['location'] = this.location;
    return data;
  }
}
