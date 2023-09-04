import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookPage extends StatefulWidget {
  final String? author;
  final String? title;
  final String url;
  final String id;
  final String DocId;

  const BookPage({
    this.author,
    this.title,
    required this.url,
    required this.id,
    required this.DocId,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  double userRating = 0.0; // Track user's rating
  bool isFavorite = false; // Track favorite status

  fetchBooksByName(String value, String? title) {
    return FirebaseFirestore.instance
        .collection("Books")
        .where('type.catalogueId', isEqualTo: value)
        .snapshots();
  }

  // Toggle favorite status
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  // Update the user's rating in Firestore with a specific DocId
  Future<void> updateRatingAndReadByInFirestore(double newRating, String docId) async {
    try {
      final ratingsQuery = FirebaseFirestore.instance
          .collection("ratings")
          .where('docId', isEqualTo: docId);

      final ratingsSnapshot = await ratingsQuery.get();

      if (ratingsSnapshot.docs.isNotEmpty) {
        final ratingsDocRef = ratingsSnapshot.docs.first.reference;
        final currentRating = ratingsSnapshot.docs.first.data()['rating'];
        final currentReadBy = ratingsSnapshot.docs.first.data()['readBy'];

        // Calculate the updated values
        final updatedRating = ((currentRating * currentReadBy) + newRating) / (currentReadBy + 1);
        final updatedReadBy = currentReadBy + 1;

        await ratingsDocRef.update({
          'rating': updatedRating,
          'readBy': updatedReadBy,
        });

        print("Rating and readBy updated successfully!");
      } else {
        print("Document with docId $docId not found in the 'ratings' collection.");
      }
    } catch (e) {
      print("Error updating rating and readBy: $e");
    }
  }


  // Fetch the user's rating from Firestore
  Future<void> fetchUserRating() async {
    try {
      final bookQuery = FirebaseFirestore.instance.collection("ratings")
          .where('docId', isEqualTo: widget.DocId); // Get the query

      final bookSnapshot = await bookQuery.get(); // Execute the query

      if (bookSnapshot.docs.isNotEmpty) {
        final bookData = bookSnapshot.docs.first.data() as Map<String, dynamic>;
        final rating = bookData['rating'];

        // Check if rating is an integer and convert it to a double
        if (rating is int) {
          setState(() {
            userRating = rating.toDouble();
          });
        } else if (rating is double) {
          setState(() {
            userRating = rating;
          });
        }
      }
    } catch (e) {
      print("Error fetching user rating: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the user's rating when the page is initialized
    fetchUserRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '${widget.title}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(0, 0, 128, 1),
          ),
        ),
        actions: [
          // Favorite icon removed from AppBar
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  height: 270,
                  child: Image.network('${widget.url}'),
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "By:- ${widget.author}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Favorite icon moved here
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: toggleFavorite,
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Handle share action here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_added_outlined), // Change to the "Read" icon
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        double rating = 0; // Initialize the rating

                        return AlertDialog(
                          title: Text("Read it? Then please rate it"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RatingBar.builder(
                                initialRating: rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 40.0,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (newRating) {
                                  rating = newRating; // Update the rating when the user selects stars
                                },
                              ),
                              SizedBox(height: 16.0), // Add spacing
                              ElevatedButton(
                                onPressed: () async {
                                  // Handle the submit action here
                                  Navigator.of(context).pop(); // Close the dialog

                                  // Use the captured DocId to update the rating in Firestore
                                  await updateRatingAndReadByInFirestore(rating, widget.DocId);
                                },
                                child: Text("Submit"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Rating"),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        color: index < userRating ? Colors.amber : Colors.grey,
                      );
                    }),
                  )
                ],
              ),
            ),

            SizedBox(height: 10),
            Text("Similar Publications"),
            Container(
              width: 150,
              child: Divider(),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Container(
                child: StreamBuilder(
                  stream: fetchBooksByName(widget.id, widget.title),
                  builder: (BuildContext context, AsyncSnapshot booksSnapshot) {
                    if (booksSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!booksSnapshot.hasData || booksSnapshot.data == null) {
                      return Text("No similar publications found.");
                    }

                    // Filter out books with null 'url'
                    final booksWithUrls = booksSnapshot.data.docs.where((bookDocument) {
                      Map<String, dynamic> bookMap = bookDocument.data() as Map<String, dynamic>;
                      String url = bookMap['url'];
                      return url != null;
                    }).toList();

                    if (booksWithUrls.isEmpty) {
                      return Text("No similar publications found.");
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: booksWithUrls.map<Widget>((bookDocument) {
                          Map<String, dynamic> bookMap = bookDocument.data() as Map<String, dynamic>;
                          String author = bookMap['author'];
                          String title = bookMap['title'];
                          String url = bookMap['url'];
                          String DocId=bookMap['docId']??'';

                          return Row(
                            children: [
                              Material(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 150, // Set a fixed width
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 200,
                                        child: InkWell(
                                          onTap: () {
                                            // Navigate to the book page with details
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => BookPage(
                                                  author: author,
                                                  title: title,
                                                  url: url,
                                                  id: widget.id,
                                                  DocId: DocId,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              url,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Text('Unable to load image from server');
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:EdgeInsets.symmetric(horizontal: 4),
                                        child:  Row(
                                          children: [
                                            if (bookMap['rating'] != null) ...[
                                              Text(bookMap['rating'].toString()), // Convert int to string
                                              Icon(Icons.star),
                                              SizedBox(width: 10,),
                                            ],
                                            Flexible(
                                              child: Container(
                                                child: Text(
                                                  bookMap['title'],
                                                  style: TextStyle(fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}