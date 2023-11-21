// import 'package:flutter/material.dart';
// import 'package:rlr/pages/book_page.dart';
// import 'package:provider/provider.dart';
// import 'package:rlr/provider/wishlist_provider.dart';
// import '../models/UserModel.dart';
// import '../provider/DbProvider.dart';
//
// class WishList extends StatefulWidget {
//   @override
//   State<WishList> createState() => _WishListState();
// }
//
// class _WishListState extends State<WishList> {
//   UserModel? userModel;
//   late WishListProvider wishListProvider;
//
//   showAlertDialog(BuildContext context, BookPage delete) {
//     Widget cancelButton = TextButton(
//       child: Text("No"),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text("Yes"),
//       onPressed: () {
//         wishListProvider.deleteWishList(delete.bookId, userModel!.authId);
//         Navigator.of(context).pop();
//       },
//     );
//
//     AlertDialog alert = AlertDialog(
//       title: Text("WishList Product"),
//       content: Text("Are you sure you want to delete this WishList Product?"),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     userModel = context.watch<DbProvider>().userModel;
//     wishListProvider = Provider.of<WishListProvider>(context);
//     wishListProvider.getWishListData(userModel!.authId);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "WishList",
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: wishListProvider.getWishList.length,
//         itemBuilder: (context, index) {
//           BookPage data = wishListProvider.getWishList[index];
//           return Column(
//             children: [
//               SizedBox(
//                 height: 10,
//               ),
//               SingleItem(
//                 url: data.url,
//                 title: data.title,
//                 bookId: data.bookId,
//                 author: data.author,
//                 onDelete: () {
//                   showAlertDialog(context, data);
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class SingleItem extends StatelessWidget {
//   final String? author;
//   final String? title;
//   final String url;
//   final String bookId;
//   final VoidCallback onDelete;
//
//   SingleItem({
//     this.author,
//     this.title,
//     required this.url,
//     required this.bookId,
//     required this.onDelete,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => BookPage(
//             author: author,
//             title: title,
//             url: url,
//             id: bookId,
//             bookId: bookId,
//           ),
//         ));
//       },
//       child: Card(
//         elevation: 0,
//         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   url,
//                   width: 120,
//                   height: 190,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(width: 12),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 8),
//                     Text(
//                       title!,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Author: $author',
//                       style: TextStyle(
//                         color: Colors.grey,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     TextButton(
//                       onPressed: onDelete,
//                       child: Icon(
//                         Icons.delete,
//                         color: Colors.blueGrey,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:rlr/pages/general_book_page_screens/book_page.dart';
import 'package:provider/provider.dart';
import 'package:rlr/provider/wishlist_provider.dart';
import '../../models/UserModel.dart';
import '../../provider/DbProvider.dart';

class WishList extends StatefulWidget {
  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  UserModel? userModel;
  late WishListProvider wishListProvider;

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
        wishListProvider.deleteWishList(delete.bookId, userModel!.authId);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("WishList Product"),
      content: Text("Are you sure you want to delete this WishList Product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

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
    wishListProvider = Provider.of<WishListProvider>(context);
    wishListProvider.getWishListData(userModel!.authId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD6D46D), // Changed "color" to "backgroundColor"
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

class SingleItem extends StatelessWidget {
  final String? author;
  final String? title;
  final String url;
  final String bookId;
  final VoidCallback onDelete;

  SingleItem({
    this.author,
    this.title,
    required this.url,
    required this.bookId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BookPage(
            author: author,
            title: title,
            url: url,
            id: bookId,
            bookId: bookId,
          ),
        ));
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: EdgeInsets.all(8), // Reduced padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8), // Reduced border radius
                child: Image.network(
                  url,
                  width: 80,  // Reduced image width
                  height: 120, // Reduced image height
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8), // Reduced spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      title!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Reduced font size
                      ),
                    ),
                    SizedBox(height: 4), // Reduced spacing
                    Text(
                      'Author: $author',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4), // Reduced spacing
                  ],
                ),
              ),
              TextButton(
                onPressed: onDelete,
                child: Icon(
                  Icons.delete,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}