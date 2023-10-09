// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:rlr/models/UserModel.dart';
// import 'package:rlr/pages/book_page.dart';
// import '../provider/DbProvider.dart';
//
// class MyBooks extends StatefulWidget {
//   const MyBooks({Key? key}) : super(key: key);
//
//   @override
//   State<MyBooks> createState() => _MyBooksState();
// }
//
// class _MyBooksState extends State<MyBooks> {
//   UserModel? userModel;
//
//   @override
//   Widget build(BuildContext context) {
//     userModel = context.watch<DbProvider>().userModel;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Books'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(userModel?.userId)
//             .collection('issuedBooks')
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           Map<String, Map<String, DateTime>> bookDateMap = {};
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'No books have been issued 😢',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 20),
//                   // Add your crying emoji asset or icon here
//                 ],
//               ),
//             );
//           }
//
//           // Populate the bookDateMap with bookId as key and date information as value
//           snapshot.data!.docs.forEach((doc) {
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//             String bookId = data['bookId'] as String;
//             Timestamp returnTimestamp = data['returnDate'] as Timestamp;
//             Timestamp issueTimestamp = data['issueDate'] as Timestamp;
//
//             // Convert Timestamp to DateTime
//             DateTime issueDate = issueTimestamp.toDate();
//             DateTime returnDate = returnTimestamp.toDate();
//
//             bookDateMap[bookId] = {
//               'issueDate': issueDate,
//               'returnDate': returnDate,
//             };
//           });
//
//           // Fetch books based on the bookIds
//           return StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('Books')
//                 .where('docId', whereIn: bookDateMap.keys.toList()) // Filter by bookIds
//                 .snapshots(),
//             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> bookSnapshot) {
//               if (bookSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               if (!bookSnapshot.hasData || bookSnapshot.data!.docs.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'No books found 😢',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       SizedBox(height: 20),
//                       // Add your crying emoji asset or icon here
//                     ],
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                 itemCount: bookSnapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   DocumentSnapshot bookDocument = bookSnapshot.data!.docs[index];
//                   Map<String, dynamic> bookData = bookDocument.data() as Map<String, dynamic>;
//                   String bookTitle = bookData['title'];
//                   String author = bookData['author'];
//                   String bookId = bookData['docId'];
//                   String url = bookData['url'];
//                   String catalogueId = bookData['type']['catalogueId'];
//
//                   // Retrieve the date information for the current book
//                   Map<String, DateTime>? dateInfo = bookDateMap[bookId];
//
//                   // Extract issueDate and returnDate, or set defaults if not found
//                   DateTime issueDate = dateInfo?['issueDate'] ?? DateTime.now();
//                   DateTime returnDate = dateInfo?['returnDate'] ?? DateTime.now();
//
//                   return BookCard(
//                     bookId: bookId,
//                     bookTitle: bookTitle,
//                     author: author,
//                     url: url,
//                     catalogueId: catalogueId,
//                     issueDate: issueDate,
//                     returnDate: returnDate,
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class BookCard extends StatefulWidget {
//   final String bookId;
//   final String bookTitle;
//   final String author;
//   final String url;
//   final String catalogueId;
//   final DateTime issueDate;
//   final DateTime returnDate;
//
//   const BookCard({
//     required this.bookId,
//     required this.bookTitle,
//     required this.author,
//     required this.url,
//     required this.catalogueId,
//     required this.issueDate,
//     required this.returnDate,
//   });
//
//   @override
//   _BookCardState createState() => _BookCardState();
// }
//
// class _BookCardState extends State<BookCard> {
//   bool isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 isExpanded = !isExpanded; // Toggle the expansion on tap
//               });
//             },
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       widget.url,
//                       width: 120,
//                       height: 190,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SizedBox(width: 16), // Add spacing between image and text
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(height: 60,),
//                         Text(
//                           widget.bookTitle,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(height: 8), // Add spacing between title and author
//                         Text(
//                           'Author: ${widget.author}',
//                           style: TextStyle(
//                             color: Colors.grey,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (isExpanded) ...[
//             SizedBox(height: 16), // Add spacing before issue and return date
//             Text('Issue Date: ${widget.issueDate.toString()}'),
//             SizedBox(height: 10,),
//             Text('Return Date: ${widget.returnDate.toString()}'),
//           ],
//           if (isExpanded)...[
//             SizedBox(height: 2,),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => BookPage(
//                     author: widget.author,
//                     title: widget.bookTitle,
//                     url: widget.url,
//                     id: widget.catalogueId,
//                     DocId: widget.bookId,
//                   ),
//                 ));
//               },
//               child: Container(
//                 color: Colors.grey[200],
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Go to book page', style: TextStyle(color: Colors.blue)),
//                     Icon(
//                       Icons.arrow_forward,
//                       color: Colors.blue,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//
//         ],
//       ),
//     );
//   }
// }
//
//
//
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:rlr/pages/book_page.dart';
import '../provider/DbProvider.dart';
import 'package:intl/intl.dart';


class MyBooks extends StatefulWidget {
  const MyBooks({Key? key}) : super(key: key);

  @override
  State<MyBooks> createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    userModel = context.watch<DbProvider>().userModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Books'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userModel?.userId)
            .collection('issuedBooks')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Map<String, Map<String, DateTime>> bookDateMap = {};

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No books have been issued 😢',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  // Add your crying emoji asset or icon here
                ],
              ),
            );
          }

          // Populate the bookDateMap with bookId as key and date information as value
          snapshot.data!.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String bookId = data['bookId'] as String;
            Timestamp returnTimestamp = data['returnDate'] as Timestamp;
            Timestamp issueTimestamp = data['issueDate'] as Timestamp;

            // Convert Timestamp to DateTime
            DateTime issueDate = issueTimestamp.toDate();
            DateTime returnDate = returnTimestamp.toDate();

            bookDateMap[bookId] = {
              'issueDate': issueDate,
              'returnDate': returnDate,
            };
          });

          // Fetch books based on the bookIds
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Books')
                .where('docId', whereIn: bookDateMap.keys.toList()) // Filter by bookIds
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> bookSnapshot) {
              if (bookSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!bookSnapshot.hasData || bookSnapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No books found 😢',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      // Add your crying emoji asset or icon here
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: bookSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot bookDocument = bookSnapshot.data!.docs[index];
                  Map<String, dynamic> bookData = bookDocument.data() as Map<String, dynamic>;
                  String bookTitle = bookData['title'];
                  String author = bookData['author'];
                  String bookId = bookData['docId'];
                  String url = bookData['url'];
                  String catalogueId = bookData['type']['catalogueId'];

                  // Retrieve the date information for the current book
                  Map<String, DateTime>? dateInfo = bookDateMap[bookId];

                  // Extract issueDate and returnDate, or set defaults if not found
                  DateTime issueDate = dateInfo?['issueDate'] ?? DateTime.now();
                  DateTime returnDate = dateInfo?['returnDate'] ?? DateTime.now();


                  return Column(
                    children: [
                      BookCard(
                        bookId: bookId,
                        bookTitle: bookTitle,
                        author: author,
                        url: url,
                        catalogueId: catalogueId,
                        issueDate: issueDate,
                        returnDate: returnDate,
                      ),
                      Divider()
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  final String bookId;
  final String bookTitle;
  final String author;
  final String url;
  final String catalogueId;
  final DateTime issueDate;
  final DateTime returnDate;

  const BookCard({
    required this.bookId,
    required this.bookTitle,
    required this.author,
    required this.url,
    required this.catalogueId,
    required this.issueDate,
    required this.returnDate,
  });

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    String formattedIssueDate = DateFormat('dd/MM/yyyy').format(widget.issueDate);
    String formattedReturnDate = DateFormat('dd/MM/yyyy').format(widget.returnDate);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BookPage(
            author: widget.author,
            title: widget.bookTitle,
            url: widget.url,
            id: widget.catalogueId,
            DocId: widget.bookId,
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
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.url,
                  width: 120,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12), // Add spacing between image and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8,),
                    Text(
                      widget.bookTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8), // Add spacing between title and author
                    Text(
                      'Author: ${widget.author}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8), // Add spacing between author and issue date
                    Text('Issue Date: ${formattedIssueDate}'),
                    SizedBox(height: 8), // Add spacing between issue date and return date
                    Text('Return Date: ${formattedReturnDate}'),
                    SizedBox(height: 8), // Add spacing between return date and button

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



