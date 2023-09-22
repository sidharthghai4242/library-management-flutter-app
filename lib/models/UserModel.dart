import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId = "";
  String authId = "";
  String name = "";
  String email = "";
  String address = "";
  String phone = "";
  String token = "";
  Subscription subscription = Subscription();
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
    user.subscription = Subscription.toObject(doc["subscription"]);
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
    map["subscription"] = subscription.toMap();
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
    map["subscription"] = subscription.toMap();
    return map;
  }
}

class Subscription {
  String description = "";
  String descriptiontitle = "";
  String issueperiod = "";
  String name = "";
  String maxbooks = "";
  String planId = "";
  double price = 0.0;
  String validity = "";

  static Subscription toObject(doc) {
    Subscription subscription = Subscription();
    subscription.description = doc["description"] ?? "";
    subscription.descriptiontitle = doc["descriptiontitle"] ?? "";
    subscription.issueperiod = doc["issueperiod"] ?? "";
    subscription.name = doc["name"] ?? "";
    subscription.maxbooks = doc["maxbooks"] ?? "";
    subscription.planId = doc["planId"] ?? "";
    subscription.price = doc["price"] ?? 0.0;
    subscription.validity = doc["validity"] ?? "";
    return subscription;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["description"] = description ?? "";
    map["descriptiontitle"] = descriptiontitle ?? "";
    map["issueperiod"] = issueperiod ?? "";
    map["name"] = name ?? "";
    map["maxbooks"] = maxbooks ?? "";
    map["planId"] = planId ?? "";
    map["price"] = price ?? 0.0;
    map["validity"] = validity ?? "";
    return map;
  }
}
