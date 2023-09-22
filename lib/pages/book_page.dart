import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookPage extends StatefulWidget {
  final String? author;
  final String? title;
  final String url;
  final String? id;
  final String DocId;

  const BookPage({
    this.author,
    this.title,
    this.id,
    required this.url,
    required this.DocId,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  double userRating = 0.0; // Track user's rating
  bool isFavorite = false; // Track favorite status
  double bookRating = 0.0; // Book's average rating
  int readByCount = 0; // Count of users who have read the book
  bool dataFetched = false;

  fetchBooksByName(String value, String title) {
    return FirebaseFirestore.instance
        .collection("Books")
        // .where('title',isNotEqualTo:title)
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
        // Document exists, update its fields
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
        // Document doesn't exist, create a new one
        await FirebaseFirestore.instance.collection("ratings").add({
          'docId': docId,
          'rating': newRating,
          'readBy': 1, // Initialize readBy to 1 for the new document
        });
        print("New document created in 'ratings' collection.");
      }

      // Fetch the updated specific book rating and readBy count
      await fetchSpecificBookRating();
    } catch (e) {
      print("Error updating rating and readBy: $e");
    }
  }


  // Fetch the book's average rating and readBy count from Firestore
  // Fetch the book's average rating and readBy count from Firestore
  Future<void> fetchSpecificBookRating() async {
    setState(() {
      dataFetched = true;
    });
    try {
      final specificBookQuery = FirebaseFirestore.instance
          .collection("ratings")
          .where('docId', isEqualTo: widget.DocId);

      final specificBookSnapshot = await specificBookQuery.get();

      if (specificBookSnapshot.docs.isNotEmpty) {
        final specificBookData = specificBookSnapshot.docs.first.data() as Map<String, dynamic>;
        final specificBookRating = specificBookData['rating'];
        final specificBookReadBy = specificBookData['readBy'];

        // Check if the rating is an integer and convert it to a double
        if (specificBookRating is int) {
          setState(() {
            userRating = specificBookRating.toDouble();
            readByCount = specificBookReadBy.toDouble();
          });
        } else if (specificBookRating is double) {
          setState(() {
            userRating = specificBookRating;
            readByCount = specificBookReadBy;
          });
        }
      } else {
        // If there are no ratings for this book yet, initialize readByCount to 0.
        setState(() {
          readByCount = 0;
        });
      }

      // Set dataFetched to true when data is fetched

    } catch (e) {
      print("Error fetching specific book rating: $e");
    }
  }

  Future<void> fetchBookRating() async {
    try {
      final ratingsQuery = FirebaseFirestore.instance
          .collection("ratings")
          .where('docId', isEqualTo: widget.DocId);

      final ratingsSnapshot = await ratingsQuery.get();

      // Initialize totalRatings and sumRatings
      int totalRatings = 0;
      double sumRatings = 0.0;

      if (ratingsSnapshot.docs.isNotEmpty) {
        totalRatings = ratingsSnapshot.docs.length;

        for (final doc in ratingsSnapshot.docs) {
          final rating = doc.data()['rating'];
          sumRatings += rating.toDouble();
        }
      }

      setState(() {
        // Update the readBy count
        bookRating = totalRatings > 0 ? sumRatings / totalRatings : 0.0;
      });

      // Set dataFetched to true when data is fetched
      setState(() {
        dataFetched = true;
      });
    } catch (e) {
      print("Error fetching book rating: $e");
    }
  }
  @override
  void initState() {
    super.initState();

    // Set initial values while waiting for data// You can set it to any default value you prefer

    // Fetch the specific book rating when the page is initialized
    fetchSpecificBookRating();

    // Fetch the average book rating when the page is initialized
    fetchBookRating();
  }


  @override
    Widget build(BuildContext context) {
    Color borderColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white24
        : Colors.black26;
    String id='${widget.id}';
    String title='${widget.title}';
    return !dataFetched
        ? (Center(child:CircularProgressIndicator()))// Show loader
        : Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${widget.title}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),

        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.pink),
        actions: [
          // Favorite icon removed from AppBar
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 5,),
                Container(
                  height: 250,
                  width: 160,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                    border: Border.all(
                      color: borderColor, // Adjust the border color as needed
                      width: 2, // Adjust the border width as needed
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12), // Adjust the value as needed
                    child: Image.network(
                      '${widget.url}',
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Unable to load image from server');
                      },
                    ),
                  ),
                ),

                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 158,
                      child: Text(
                        '${widget.title}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${widget.author}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange),
                    ),
                    SizedBox(height: 5), // Add a SizedBox with a height of 5
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle the "Add to Cart" button click here
                        // You can implement the cart functionality here, such as adding the book to the user's cart.
                        // You may also want to display a confirmation message.
                      },
                      icon: Icon(Icons.add_shopping_cart), // Add an icon to the button
                      label: Text("Add to Cart"), // Add text to the button
                    ),
                  ],
                )

              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Rating",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  Container(
                    width: 90,
                    child: Divider(),
                  ),
                  SizedBox(height: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Row(
                        children: [
                          Icon(
                            index < userRating.floor()
                                ? Icons.star
                                : (index < userRating.ceil()
                                ? Icons.star_half
                                : Icons.star_border),
                            color: Colors.amber,
                            size: 40.0,
                          ),
                        ],
                      );
                    }),
                  ),
                      SizedBox(height: 5),
                      Text('('+readByCount.toString()+')',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Favorite icon moved here
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: toggleFavorite,
                    ),
                    Row(children: [
                      Text("Wishlist"),
                    ],),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        // Handle share action here
                      },
                    ),
                    Row(children: [
                      SizedBox(width: 4,),
                      Text("Share"),
                    ],),
                  ],
                ),
                Column(
                  children: [
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
                                    initialRating: 0, // Use the user's specific book rating
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 35.0,
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
                    Row(children: [
                      SizedBox(width: 4,),
                      Text("Review"),
                    ],),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Similar Publications"),
            Container(
              width: 150,
              child: Divider(),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
                child: StreamBuilder(
                  stream: fetchBooksByName(id, title),
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
                          String secondtitle = bookMap['title'];
                          String url = bookMap['url'];
                          String DocId = bookMap['docId'] ?? '';
                          return Row(
                            children: [
                              if(secondtitle !=widget.title)...[
                                Material(
                                  child: Container(
                                    height:320,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                                      border: Border.all(
                                        color: borderColor, // Adjust the border color as needed
                                        width: 2, // Adjust the border width as needed
                                      ),
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
                                                  builder: (context) =>
                                                      BookPage(
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
                                              borderRadius: BorderRadius.circular(15),
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
                                          padding: EdgeInsets.symmetric(horizontal: 4),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "By $author",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              SizedBox(height: 4),
                                              // if (bookRating > 0.0) ...[
                                              Row(
                                                children: [
                                                  Text(
                                                    bookRating.toStringAsFixed(1),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ],
                                            // ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
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
