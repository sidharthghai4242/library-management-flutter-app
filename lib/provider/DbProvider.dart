import 'package:rlr/helper/CommonClass.dart';
import 'package:rlr/helper/Constants.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/book_page.dart';

class DbProvider extends ChangeNotifier {
  FirebaseFirestore? _firestore;

  UserModel? userModel;

  DbProvider() {
    _firestore = FirebaseFirestore.instance;
  }
  addWishListData({
    String? wishlistId,
    String? wishlistName,
    String? wishlistImage,
    String? wishlistAuthor,
  }) {
    print(userModel?.userId);
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel?.userId)
        .collection("wishList")
        .doc(wishlistId)
        .set({
      "wishlistId": wishlistId,
      "wishlistName": wishlistName,
      "wishlistImage": wishlistImage,
      "wishlistAuthor": wishlistAuthor,
      "wishlist": true,
    });
  }
  //   GET WISHLIST DATA
  List<BookPage> WishList = [];

  getWishListData() async {
    List<BookPage> newList = [];
    QuerySnapshot value = await FirebaseFirestore.instance
        .collection("users")
        .doc('VkMhC98aY4zy2LlS948V')
        .collection("wishList")
        .get();
    value.docs.forEach(
          (element) {
        BookPage productModel = BookPage(
          bookId: element.get("wishlistId"),
          title: element.get("wishlistName"),
          url: element.get("wishlistImage"),
          author: element.get("wishlistAuthor"),
        );
        newList.add(productModel);
      },
    );
    WishList = newList;
    notifyListeners(); //figure this one out

  }


  List<BookPage> get getWishList {
    return WishList;
  }
//   DELETE WISHLIST ITEMS
  deleteWishList(wishlistId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc('VkMhC98aY4zy2LlS948V')
        .collection("wishList")
        .doc(wishlistId) // Use the passed wishlistId here
        .delete();
  }

  void setUserModel(UserModel userModel) {
    userModel = userModel;
    print(">>>> "+ userModel.toString());
    notifyListeners();
  }

  Future getUserFromFirestore({BuildContext? bContent, User? user}) async {
    return await _firestore?.collection("users")
      .where("email", isEqualTo: user!.email)
      .get()
      .then((value) async {
        print('getUserFromFirestore size${value.size}');
        if(value.size == 0) {
          UserModel newUserModel = await CommonClass.askedUserInfoViaModalBottomSheet(bContent!,
            isEditable: true,
            isRegistrationProcess: true,
            user: UserModel(),
            firebaseUser: user,
          );
          userModel = newUserModel;
          print('usermodel 1 ${userModel}');
          setUserModel(userModel!);
          return userModel;
        } else {
          userModel = UserModel.toObject(value.docChanges.first.doc.data());
          print('usermodel 1 ${userModel}');
          setUserModel(userModel!);
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