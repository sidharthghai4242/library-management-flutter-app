import 'package:flutter/material.dart';
import 'package:rlr/pages/general_book_page_screens/book_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishListProvider with ChangeNotifier {
  addWishListData({
    String? wishlistId,
    String? wishlistName,
    String? wishlistImage,
    String? wishlistAuthor,
    String? wishlistCatalogueId,
    String? authId,
  }) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(authId)
        .collection("wishList")
        .doc(wishlistId)
        .set({
      "wishlistId": wishlistId,
      "wishlistName": wishlistName,
      "wishlistImage": wishlistImage,
      "wishlistAuthor": wishlistAuthor,
      "wishlistCatalogueId":wishlistCatalogueId,
      "wishlistedOn": Timestamp.now(),
      "wishlist": true,
    });
  }

  //   GET WISHLIST DATA
  List<BookPage> WishList = [];

  getWishListData(String? authId) async {
    List<BookPage> newList = [];
    QuerySnapshot value = await FirebaseFirestore.instance
        .collection("users")
        .doc(authId)
        .collection("wishList")
        .orderBy("wishlistedOn", descending: true)
        .get();
    value.docs.forEach(
          (element) {
        BookPage productModel = BookPage(
          bookId: element.get("wishlistId"),
          title: element.get("wishlistName"),
          url: element.get("wishlistImage"),
          author: element.get("wishlistAuthor"),
          id: element.get("wishlistCatalogueId"),
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
  deleteWishList(wishlistId,String? authId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(authId)
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
//           .doc(userModel?.authId)
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