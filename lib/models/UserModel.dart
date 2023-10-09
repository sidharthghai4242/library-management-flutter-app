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
  int issueperiod = 0; // Update the type to int
  String name = "";
  int maxbooks = 0; // Update the type to int
  String planId = "";
  int price = 0;
  int validity = 0;

  static Subscription toObject(doc) {
    Subscription subscription = Subscription();
    subscription.description = doc["description"] ?? "";
    subscription.descriptiontitle = doc["descriptiontitle"] ?? "";
    subscription.issueperiod = doc["issueperiod"] ?? 0;
    subscription.name = doc["name"] ?? "";
    subscription.maxbooks = doc["maxbooks"] ?? 0;
    subscription.planId = doc["planId"] ?? "";
    subscription.price = doc["price"] ?? 0;
    subscription.validity = doc["validity"] ?? 0 ;
    return subscription;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["description"] = description ?? "";
    map["descriptiontitle"] = descriptiontitle ?? "";
    map["issueperiod"] = issueperiod ?? 0;
    map["name"] = name ?? "";
    map["maxbooks"] = maxbooks ?? 0;
    map["planId"] = planId ?? "";
    map["price"] = price ?? 0;
    map["validity"] = validity ?? 0;
    return map;
  }
}
