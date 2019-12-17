class UserPassword {
  String user;
  String password;
  String firebaseToken;

  UserPassword({this.user, this.password, this.firebaseToken});

  UserPassword.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    password = json['password'];
    firebaseToken = json['firebaseToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['password'] = this.password;
    data['firebaseToken'] = this.firebaseToken;
    return data;
  }
}