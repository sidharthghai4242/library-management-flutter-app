import 'package:flutter/material.dart';
import 'package:rlr/pages/book_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishListProvider with ChangeNotifier {
  addWishListData({
    String? wishlistId,
    String? wishlistName,
    String? wishlistImage,
    String? wishlistAuthor,
    String? userId,
  }) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
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

  getWishListData(String? userId) async {
    List<BookPage> newList = [];
    QuerySnapshot value = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
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
  deleteWishList(wishlistId,String? userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("wishList")
        .doc(wishlistId) // Use the passed wishlistId here
        .delete();
  }
}


// import 'dart:js';
// import 'package:rlr/provider/DbProvider.dart';
// import 'package:rlr/helper/CommonClass.dart';
// import 'package:rlr/helper/Constants.dart';
// import 'package:provider/provider.dart';
// import 'package:rlr/models/UserModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class WishListProvider with ChangeNotifier {
//   Future<void> addWishListData({
//     String? wishlistId,
//     String? wishlistName,
//     String? wishlistImage,
//     String? wishlistAuthor,
//   }) async {
//     UserModel?userModel;
//     userModel = context.watch<DbProvider>().userModel;
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(userModel?.userId)
//           .collection("wishlist")
//           .add({
//         "wishlistId": wishlistId,
//         "wishlistName": wishlistName,
//         "wishlistImage": wishlistImage,
//         "wishlistAuthor": wishlistAuthor,
//         "wishlist": true,
//       });
//     }
//   }
// }