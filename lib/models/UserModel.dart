import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserModel {
//   String? authId;
//   // String? authId;
//   String name = "";
//   String email = "";
//   String address = "";
//   String phone = "";
//   String token = "";
//   Subscription subscription = Subscription();
//   int? age;
//   Timestamp createdOn = Timestamp.now();
//
//   UserModel() {
//     createdOn = Timestamp.now();
//   }
//
//   static UserModel toObject(doc) {
//     UserModel user = UserModel();
//     user.phone = doc["phone"];
//     // user.authId = doc["authId"] ?? "";
//     user.createdOn = doc["createdOn"];
//     user.name = doc["name"];
//     user.email = doc["email"];
//     user.address = doc["address"];
//     user.age = doc["age"] ?? 0;
//     user.authId = doc["authId"] ?? "";
//     user.token = doc["token"] ?? "";
//     user.subscription = Subscription.toObject(doc["subscription"]);
//     return user;
//   }
//
//   Map<String, dynamic> getMap() {
//     Map<String, dynamic> map = <String, dynamic>{};
//     map["phone"] = phone ?? "";
//     // map["authId"] = authId ?? "";
//     map["createdOn"] = createdOn ?? Timestamp.now();
//     map["name"] = name ?? "";
//     map["email"] = email ?? "";
//     map["address"] = address ?? "";
//     map["age"] = age ?? 0;
//     map["authId"] = authId ?? "";
//     map["token"] = token ?? "";
//     map["subscription"] = subscription.toMap();
//     return map;
//   }
//
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = <String, dynamic>{};
//     map["phone"] = phone ?? "";
//     // map["authId"] = authId ?? "";
//     map["createdOn"] = createdOn ?? Timestamp.now();
//     map["name"] = name ?? "";
//     map["email"] = email ?? "";
//     map["address"] = address ?? "";
//     map["age"] = age ?? 0;
//     map["authId"] = authId ?? "";
//     map["token"] = token ?? "";
//     map["subscription"] = subscription.toMap();
//     return map;
//   }
// }
class UserModel {
  String? authId;
  String name = "";
  String email = "";
  String address = "";
  String phone = "";
  String token = "";
  Subscription subscription = Subscription();
  int? age;
  Timestamp createdOn = Timestamp.now();
  Timestamp? expiryDate; // New field

  UserModel() {
    createdOn = Timestamp.now();
  }

  static UserModel toObject(doc) {
    UserModel user = UserModel();
    user.phone = doc["phone"];
    user.createdOn = doc["createdOn"];
    user.name = doc["name"];
    user.email = doc["email"];
    user.address = doc["address"];
    user.age = doc["age"] ?? 0;
    user.authId = doc["authId"] ?? "";
    user.token = doc["token"] ?? "";
    user.expiryDate = doc["expiryDate"]; // Assigning expiryDate if present
    user.subscription = Subscription.toObject(doc["subscription"]);
    return user;
  }

  Map<String, dynamic> getMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["phone"] = phone ?? "";
    map["createdOn"] = createdOn ?? Timestamp.now();
    map["name"] = name ?? "";
    map["email"] = email ?? "";
    map["address"] = address ?? "";
    map["age"] = age ?? 0;
    map["authId"] = authId ?? "";
    map["token"] = token ?? "";
    map["subscription"] = subscription.toMap();
    if (expiryDate != null) {
      map["expiryDate"] = expiryDate; // Adding expiryDate if present
    }
    return map;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["phone"] = phone ?? "";
    map["createdOn"] = createdOn ?? Timestamp.now();
    map["name"] = name ?? "";
    map["email"] = email ?? "";
    map["address"] = address ?? "";
    map["age"] = age ?? 0;
    map["authId"] = authId ?? "";
    map["token"] = token ?? "";
    map["subscription"] = subscription.toMap();
    if (expiryDate != null) {
      map["expiryDate"] = expiryDate; // Adding expiryDate if present
    }
    return map;
  }
}

class Subscription {
  String description = "";
  String descriptionTitle = "";
  int issuePeriod = 0; // Update the type to int
  String name = "";
  int maxBooks = 0; // Update the type to int
  String planID = "";
  int price = 0;
  int validity = 0;

  static Subscription toObject(doc) {
    Subscription subscription = Subscription();
    subscription.description = doc["description"] ?? "";
    subscription.descriptionTitle = doc["descriptionTitle"] ?? "";
    subscription.issuePeriod = doc["issuePeriod"] ?? 0;
    subscription.name = doc["name"] ?? "";
    subscription.maxBooks = doc["maxBooks"] ?? 0;
    subscription.planID = doc["planID"] ?? "";
    subscription.price = doc["price"] ?? 0;
    subscription.validity = doc["validity"] ?? 0 ;
    return subscription;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map["description"] = description ?? "";
    map["descriptionTitle"] = descriptionTitle ?? "";
    map["issuePeriod"] = issuePeriod ?? 0;
    map["name"] = name ?? "";
    map["maxBooks"] = maxBooks ?? 0;
    map["planID"] = planID ?? "";
    map["price"] = price ?? 0;
    map["validity"] = validity ?? 0;
    return map;
  }
}
