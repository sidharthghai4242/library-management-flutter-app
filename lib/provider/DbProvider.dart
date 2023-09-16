import 'package:rlr/helper/CommonClass.dart';
import 'package:rlr/helper/Constants.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DbProvider extends ChangeNotifier {
  FirebaseFirestore? _firestore;

  UserModel? userModel;

  DbProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  void setUserModel(UserModel userModel) {
    userModel = userModel;
    print(">>>> "+ userModel.toString());
    notifyListeners();
  }

  Future getUserFromFirestore({BuildContext? bContent, User? user}) async {
    return await _firestore?.collection(Constants.userCollection)
      .where("authId", isEqualTo: user!.uid)
      .get()
      .then((value) async {
        if(value.size == 0) {
          UserModel newUserModel = await CommonClass.askedUserInfoViaModalBottomSheet(bContent!,
            isEditable: true,
            isRegistrationProcess: true,
            user: UserModel(),
            firebaseUser: user,
          );
          userModel = newUserModel;
          DbProvider().setUserModel(userModel!);
          return userModel;
        } else {
          userModel = UserModel.toObject(value.docChanges.first.doc.data());
          DbProvider().setUserModel(userModel!);
          return userModel;
        }
      }).catchError((error) {
        debugPrint(">>> Error while fetching data");
        debugPrint(error.toString());
      });
  }

  Future<bool?> saveUserInFirestore({BuildContext? context, UserModel? userModel}) async {
    CommonClass().showLoadingErrorModalBottomSheet(context!);
    return await _firestore?.collection(Constants.userCollection)
      .doc(userModel!.userId)
      .set(userModel.getMap(), SetOptions(merge: true))
      .then((value) {
        Navigator.pop(context);
        return true;
    })
      .catchError((error) {
        Navigator.pop(context);
        print(">>> Error while writing in firestore");
        print(error.toString());
        return false;
      });
  }
}