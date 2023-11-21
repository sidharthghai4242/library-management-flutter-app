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
    String date="";
    userModel = context.watch<DbProvider>().userModel;
    print("-----------------------------------------------------");
    print(userModel?.authId);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height-76.260 ,
        color: Color(0xFF111111),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userModel?.authId)
              .collection('issuedBooks')
              .where('returnDate', isNull: true)
              .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            Map<String, Map<String, DateTime>> bookDateMap = {};

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(""),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No books have been issued 😢',
                      style: TextStyle(fontSize: 18,color: Colors.white),
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
              Timestamp returnTimestamp = data['dueDate'] as Timestamp;
              Timestamp issueTimestamp = data['issueDate'] as Timestamp;

              // Convert Timestamp to DateTime
              DateTime issueDate = issueTimestamp.toDate();
              print("---------------------------------------------------");
              print(issueDate.toString());
              DateTime dueDate = returnTimestamp.toDate();
              date=dueDate.toString();
              bookDateMap[bookId] = {
                'issueDate': issueDate,
                'dueDate': dueDate,
              };
            });

            // Fetch books based on the bookIds
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Books')
                  .where('bookId', whereIn: bookDateMap.keys.toList()) // Filter by bookIds
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> bookSnapshot) {
                if (bookSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text("Loading Awesomeness",style: TextStyle(fontWeight: FontWeight.bold),),
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
                    String bookId = bookData['bookId'];
                    String url = bookData['url'];
                    String catalogueId=bookData['type']['catalogueId'];


                    // Retrieve the date information for the current book
                    Map<String, DateTime>? dateInfo = bookDateMap[bookId];

                    // Extract issueDate and dueDate, or set defaults if not found
                    DateTime issueDate = dateInfo?['issueDate'] ?? DateTime.now();
                    DateTime dueDate = dateInfo?['dueDate'] ?? DateTime.now();


                    return Column(
                      children: [
                        BookCard(
                          bookId: bookId,
                          bookTitle: bookTitle,
                          author: author,
                          url: url,
                          catalogueId: catalogueId,
                          issueDate: issueDate,
                          dueDate: dueDate,
                        ),
                        // Divider()
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
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
  final DateTime dueDate;

  const BookCard({
    required this.bookId,
    required this.bookTitle,
    required this.author,
    required this.url,
    required this.catalogueId,
    required this.issueDate,
    required this.dueDate,
  });

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    String formattedIssueDate = DateFormat('dd/MM/yyyy').format(widget.issueDate);
    String formatteddueDate = DateFormat('dd/MM/yyyy').format(widget.dueDate);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BookPage(
            author: widget.author,
            title: widget.bookTitle,
            url: widget.url,
            id: widget.catalogueId,
            bookId: widget.bookId,
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
                    Text('Due Date: ${formatteddueDate}'),
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