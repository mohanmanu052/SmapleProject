class UserModel {
  int? id;
  int? userId;
  String? title;
  String? body;
  UserModel({this.id, this.userId, this.title, this.body});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        body: json['body']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'body': body
    };
  }
}
