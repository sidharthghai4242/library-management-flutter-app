import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId = "";
  String authId = "";
  String name = "";
  String email = "";
  String address = "";
  String phone = "";
  String token = "";
  String subscription = "";
  String password = "";
  int age = 0;
  Timestamp createdOn = Timestamp.now();

  UserModel() {
    createdOn = Timestamp.now();
  }

  static UserModel toObject(doc) {
    UserModel user = UserModel();
    user.phone = doc["phone"];
    user.authId = doc["authId"];
    user.createdOn = doc["createdOn"];
    user.name = doc["name"];
    user.email = doc["email"];
    user.address = doc["address"];
    user.age = doc["age"];
    user.userId = doc["userId"];
    user.token = doc["token"];
    user.subscription = doc["subscription"];
    user.password = doc["password"];
    return user;
  }

  Map<String, dynamic> getMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["phone"] = phone ?? "";
    map["authId"] = authId ?? "";
    map["createdOn"] = createdOn ?? Timestamp.now();
    map["name"] = name ?? "";
    map["email"] = email ?? "";
    map["address"] = address ?? "";
    map["age"] = age ?? 0;
    map["userId"] = userId ?? "";
    map["token"] = token ?? "";
    map["subscription"] = subscription ?? "";
    map["password"] = password ?? "";
    return map;
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["phone"] = phone ?? "";
    map["authId"] = authId ?? "";
    map["createdOn"] = createdOn ?? Timestamp.now();
    map["name"] = name ?? "";
    map["email"] = email ?? "";
    map["address"] = address ?? "";
    map["age"] = age ?? 0;
    map["userId"] = userId ?? "";
    map["token"] = token ?? "";
    map["subscription"] = subscription ?? "";
    map["password"] = password ?? "";
    return map;
  }
}


