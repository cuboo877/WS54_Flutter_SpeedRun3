class UserData {
  final String id;
  late String username;
  late String account;
  late String password;
  late String birthday;

  UserData(this.id, this.username, this.account, this.password, this.birthday);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "account": account,
      "password": password,
      "birthday": birthday
    };
  }
}

class PasswordData {
  final String id;
  final String userID;
  late String tag;
  late String url;
  late String login;
  late String password;
  late int isFav;

  PasswordData(this.id, this.userID, this.tag, this.url, this.login,
      this.password, this.isFav);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userID": userID,
      "tag": tag,
      "login": login,
      "url": url,
      "password": password,
      "isFav": isFav
    };
  }
}
