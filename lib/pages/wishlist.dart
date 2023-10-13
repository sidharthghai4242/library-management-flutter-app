import 'package:flutter/material.dart';
import 'package:rlr/pages/book_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:rlr/provider/wishlist_provider.dart';

import '../models/UserModel.dart';
import '../provider/DbProvider.dart';

class WishList extends StatefulWidget {
  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  UserModel?userModel;
  late WishListProvider wishListProvider;
  // WishListProvider wishListProvider;
  showAlertDialog(BuildContext context, BookPage delete) {
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        // WishListProvider wishListProvider = Provider.of<WishListProvider>(context, listen: false);
        wishListProvider.deleteWishList(delete.bookId,userModel?.userId as String);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("WishList Product"),
      content: Text("Are you sure you want to delete this WishList Product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    userModel = context.watch<DbProvider>().userModel;
    // wishListProvider = Provider.of<WishListProvider>(context);
    wishListProvider = Provider.of(context);
    wishListProvider.getWishListData(userModel?.userId as String );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "WishList",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView.builder(
        itemCount: wishListProvider.getWishList.length,
        itemBuilder: (context, index) {
          BookPage data = wishListProvider.getWishList[index];
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SingleItem(
                url: data.url,
                title: data.title,
                bookId: data.bookId,
                author: data.author,
                onDelete: () {
                  showAlertDialog(context, data);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class SingleItem extends StatefulWidget {
  final String? author;
  final String? title;
  final String url;
  final String? id;
  final String bookId;
  final Function onDelete;


  SingleItem({
    this.author,
    this.title,
    this.id,
    required this.url,
    required this.bookId,
    required this.onDelete,
  });
  @override
  _SingleItemState createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  // ReviewCartProvider? reviewCartProvider;
  // int count = 0;

  @override
  void initState() {
    super.initState();
    // getCount();
  }

  // void getCount() {
  //   setState(() {
  //     count = widget.productQuantity ?? 0;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // reviewCartProvider = Provider.of<ReviewCartProvider>(context);
    // reviewCartProvider?.getReviewCartData();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 90,
                  child: Center(
                    child: Image.network(
                      widget.url,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title ?? "",
                            style: TextStyle(

                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "\$${widget.author}",
                            style: TextStyle(

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 90,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: widget.onDelete as void Function()?,
                        child: Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.black45,
        ),
      ],
    );
  }
}