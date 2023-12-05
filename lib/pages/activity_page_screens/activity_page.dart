import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';

import '../../provider/DbProvider.dart';
import '../../widgets/bargraphwidget.dart';
import '../general_book_page_screens/book_page.dart';
import '../my_books_page_screens/my_books.dart';
class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  UserModel? userModel;
  int? booksIssued;
  int total_issued_books=0;
  int books_currently_with_you=0;
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> calculateIssuedBooksStats(String? userId) async {
    try {
      // Get the total number of documents in the 'issuedBooks' subcollection
      QuerySnapshot<Map<String, dynamic>> totalIssuedBooksSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('issuedBooks')
          .get();

      // Calculate the total number of issued books
      int totalIssuedBooks = totalIssuedBooksSnapshot.size;

      // Get the number of documents where the 'returnDate' field is null
      QuerySnapshot<Map<String, dynamic>> booksCurrentlyWithUserSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('issuedBooks')
          .where('returnDate', isNull: true)
          .get();

      // Calculate the number of books currently with the user
      int booksCurrentlyWithUser = booksCurrentlyWithUserSnapshot.size;

      // Update the variables
      total_issued_books = totalIssuedBooks;
      books_currently_with_you = booksCurrentlyWithUser;

      // Print the calculated values (for testing, you can remove this in production)
      print('Total Issued Books: $totalIssuedBooks');
      print('Books Currently With You: $booksCurrentlyWithUser');
    } catch (e) {
      print('Error calculating issued books stats: $e');
    }
  }

  Future<int?> getBooksIssuedForCurrentMonth() async {
    try {
      // Get current year and month
      DateTime now = DateTime.now();
      String yearMonth = '${now.year}${now.month.toString().padLeft(2, '0')}';
      print("yearMonth: "+yearMonth);
      // Reference to the Firestore document
      String? userId = userModel?.authId; // Replace with your user ID
      DocumentSnapshot userStatsDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userStats')
          .doc(yearMonth)
          .get();

      if (userStatsDoc.exists) {
        // Explicitly cast data to Map<String, dynamic>
        Map<String, dynamic>? data = userStatsDoc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('booksIssued')) {
          // Retrieve the booksIssued field
          booksIssued = data['booksIssued'] as int?;
          return booksIssued;
        } else {
          print('booksIssued field is missing in the document for $yearMonth');
          return null;
        }
      } else {
        // Document doesn't exist for the current year and month
        print('Document does not exist for $yearMonth');
        booksIssued = 0;
        return booksIssued;
      }
    } catch (e) {
      print('Error fetching document: $e');
      return null;
    }
  }
  Future<void> fetchData() async {
    await getBooksIssuedForCurrentMonth();
    await calculateIssuedBooksStats(userModel?.authId);
    setState(() {}); // Trigger UI update after fetching data
  }
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double widthOfBookBox= screenwidth;
    if (widthOfBookBox > 400) {
      widthOfBookBox = 400;
    }
    // getBooksIssuedForCurrentMonth();
    // calculateIssuedBooksStats(userModel?.authId);
    print(booksIssued.toString()+"current issued books");
    String date="";
    userModel = context.watch<DbProvider>().userModel;
    String formattedJoinDate = userModel?.createdOn != null
          ? DateFormat('dd/MM/yyyy').format(userModel!.createdOn.toDate())
          : 'Loading...';
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
              .orderBy('issueDate')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            Map<String, Map<String, dynamic>> bookDateMap = {};

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
                      'Try issuing some books to\n start your journey with us.',
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
              Timestamp? dueTimestamp = data['returnDate'] as Timestamp?;
              String returnDateString;

              if (dueTimestamp != null) {
                DateTime returnDate = dueTimestamp.toDate();
                returnDateString = DateFormat('dd/MM/yyyy').format(returnDate);
              } else {
                returnDateString = 'Book not returned yet';
              }
              DateTime issueDate = issueTimestamp.toDate();
              DateTime dueDate = returnTimestamp.toDate();
              date=dueDate.toString();
              bookDateMap[bookId] = {
                'issueDate': issueDate,
                'dueDate': dueDate,
                'returnDate':returnDateString
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
                    child: Text(
                      "Loading Awesomeness",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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

                // Check if bookSnapshot has data and display the ListView along with the "Book Activity" text
                return Container(
                  height: MediaQuery.of(context).size.height ,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          SizedBox(height: 5),
                          Text(
                            'Issue and Return Activity',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    if(userModel!.subscription.name.isNotEmpty)...[
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        height: 200,
                                        width: widthOfBookBox*0.93,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                                width: 1,
                                                color: Color(0xFFA37E49)
                                            )
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10,),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(userModel!.subscription.maxBooks.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                                                    SizedBox(height: 5,),
                                                    Text(
                                                      "Max. books that can\nbe issued",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(booksIssued.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                                                    SizedBox(height: 5,),
                                                    Text(
                                                      "Books issued this month",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 10,),
                                              ],
                                            ),
                                            SizedBox(height: 20,),
                                            Row(
                                              children: [
                                                SizedBox(width: 10,),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(total_issued_books.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                                                    SizedBox(height: 5,),
                                                    Text(
                                                      "Total books issued by\nyou till date",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(books_currently_with_you.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
                                                    SizedBox(height: 5,),
                                                    Text(
                                                      "Books currently with you",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 10,),
                                              ],
                                            ),
                                          ],
                                        )
                                      )
                                    ],
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height-384.260 ,
                                child: ListView.builder(
                                  itemCount: bookSnapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot bookDocument = bookSnapshot.data!.docs[index];
                                    Map<String, dynamic> bookData =
                                    bookDocument.data() as Map<String, dynamic>;
                                    String bookTitle = bookData['title'];
                                    String author = bookData['author'];
                                    String bookId = bookData['bookId'];
                                    String url = bookData['url'];
                                    String catalogueId = bookData['type']['catalogueId'];

                                    // Retrieve the date information for the current book
                                    Map<String, dynamic>? dateInfo = bookDateMap[bookId];

                                    // Extract issueDate and dueDate, or set defaults if not found
                                    DateTime issueDate =
                                        dateInfo?['issueDate'] ?? DateTime.now();
                                    DateTime dueDate = dateInfo?['dueDate'] ?? DateTime.now();
                                    String returnDate =
                                        dateInfo?['returnDate'] ?? "Book not returned yet";

                                    return Column(
                                      children: [
                                        Bookscard(
                                          bookId: bookId,
                                          bookTitle: bookTitle,
                                          author: author,
                                          url: url,
                                          catalogueId: catalogueId,
                                          issueDate: issueDate,
                                          dueDate: dueDate,
                                          returnDate: returnDate,
                                        ),
                                        // Divider()
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      )
    );
  }


  Future<List<Map<String, dynamic>>> _fetchBookActivities() async {
    List<Map<String, dynamic>> bookActivities = [];

    if (userModel != null) {
      QuerySnapshot<Map<String, dynamic>> issuedBooksSnapshot =
      await FirebaseFirestore.instance
          .collection('users/${userModel!.authId}/issuedBooks')
          .orderBy('issueDate') // Sort by issueDate in ascending order
          .get();

      for (var doc in issuedBooksSnapshot.docs) {
        String title = doc['title'];
        DateTime issueDate = doc['issueDate'].toDate();
        DateTime? returnDate = doc['returnDate'] != null
            ? doc['returnDate'].toDate()
            : null;

        // Check if 'returnDate' field is present and not null in the document
        if (doc.data()!.containsKey('returnDate') && returnDate != null) {
          bookActivities.add({
            'title': title,
            'issueDate': DateFormat('dd/MM/yyyy').format(issueDate),
            'returnDate': DateFormat('dd/MM/yyyy').format(returnDate),
          });
        } else {
          bookActivities.add({
            'title': title,
            'issueDate': DateFormat('dd/MM/yyyy').format(issueDate),
          });
        }
      }
    }

    return bookActivities;
  }
}
class Bookscard extends StatefulWidget {
  final String bookId;
  final String bookTitle;
  final String author;
  final String url;
  final String catalogueId;
  final DateTime issueDate;
  final DateTime dueDate;
  final String returnDate;

  const Bookscard({
    required this.bookId,
    required this.bookTitle,
    required this.author,
    required this.url,
    required this.catalogueId,
    required this.issueDate,
    required this.dueDate,
    required this.returnDate
  });

  @override
  State<Bookscard> createState() => _BookscardState();
}

class _BookscardState extends State<Bookscard> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double widthOfBookBox= screenwidth;
    if (widthOfBookBox > 400) {
      widthOfBookBox = 400;
    }
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
      child: Container(
        width:  widthOfBookBox ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Container(
                      height: 195,
                      child: VerticalDivider(color: Colors.white,),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 80,),
                    Row(
                      children: [
                        SizedBox(width: 10,),
                       Stack(
                         children: [
                           Container(
                             height: 36,
                             width: 36,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(60)
                             ),
                           ),
                          Row(
                            children: [
                              SizedBox(width:3,),
                             Column(
                               children: [
                                 SizedBox(
                                   height: 2,
                                 ),
                                 Icon(Icons.timer_sharp,size: 30,color: Colors.black,)
                               ],
                             )
                            ],
                          )
                         ],
                       )
                      ],
                    )
                  ],
                ),
                SizedBox(width: 45,),
              ],
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: widthOfBookBox*0.75,
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.url,
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8), // Add spacing between image and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6,),
                          Text(
                            widget.bookTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 6), // Add spacing between title and author
                          Text(
                            'Author: ${widget.author}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 6), // Add spacing between author and issue date
                          Text('Issue Date: ${formattedIssueDate}',style: TextStyle(fontSize: 12),),
                          SizedBox(height: 6), // Add spacing between issue date and return date
                          Text('Return Date: ${widget.returnDate}',style: TextStyle(fontSize: 12),),
                          SizedBox(height: 6), // Add spacing between return date and button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
