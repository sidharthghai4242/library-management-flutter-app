
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:share_plus/share_plus.dart';

import '../provider/DbProvider.dart';
import '../provider/wishlist_provider.dart';

class BookPage extends StatefulWidget {
  final String? author;
  final String? title;
  final String url;
  final String? id;
  final String bookId;

  const BookPage({
    this.author,
    this.title,
    this.id,
    required this.url,
    required this.bookId,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  double userRating = 0.0; // Track user's rating
  // bool isFavorite = false; // Track favorite status
  double bookRating = 0.0; // Book's average rating
  int readByCount = 0; // Count of users who have read the book
  bool dataFetched = false;
  bool isRatingUpdateInProgress = false;
  UserModel?userModel;
  TextEditingController review =TextEditingController();
  double storedRating = 5.0;
  final int maxCharacterLimit = 150;
  double updatedRating=0.0;
  Color primaryColorLight = Colors.white; // Soft sky blue// Soft pastel blue
  Color secondaryColorLight = Color(0xFF990000); // Bright orange
  Color tertiaryColorLight = Color(0xFF3E2723);
  Color neutralColorLight=Color(0xFF0A1746);// Dark chocolate brown
  Color primaryColorDark = Color(0xFF000000); // Midnight blue
  Color secondaryColorDark = Colors.deepPurple; // Electric purple// You can also use Colors.purpleAccent.
  Color tertiaryColorDark = Color(0xFFE900FF);
  Color neutralColorDark=Color(0xFFFFC600);


  fetchBooksByName(String value, String title) {
    return FirebaseFirestore.instance
        .collection("Books")
        // .where('title',isNotEqualTo:title)
        .where('type.catalogueId', isEqualTo: value)
        .snapshots();
  }

  // Toggle favorite status
  // void toggleFavorite() {
  //   setState(() {
  //     isFavorite = !isFavorite;
  //   });
  // }
  Future<void> updateRatingAndReadByInFirestore(double newRating, String bookId, String uid, String reviewText) async {
    try {
      final ratingsQuery = FirebaseFirestore.instance
          .collection("ratings")
          .where('bookId', isEqualTo: bookId);

      final ratingsSnapshot = await ratingsQuery.get();

      if (ratingsSnapshot.docs.isNotEmpty) {
        // Document exists, update its fields
        final ratingsDocRef = ratingsSnapshot.docs.first.reference;

        // Check if the user's UID is already in the "readBy" list
        final currentReadBy = ratingsSnapshot.docs.first.data()['readBy'] as List<dynamic>;

        bool userExists = false;

        for (var userEntry in currentReadBy) {
          if (userEntry['uid'] == uid) {
            // User's UID is already in the list, update their rating and comment
            userEntry['rating'] = newRating;
            userEntry['comment'] = reviewText;
            userExists = true;
            break;
          }
        }

        if (!userExists) {
          // User's UID is not in the list, add their entry
          currentReadBy.add({
            'uid': uid,
            'name': FirebaseAuth.instance.currentUser?.displayName,
            'rating': newRating,
            'comment': reviewText,
          });
        }

        // Calculate the updated rating as the average of all ratings in the "readBy" field
        double totalRating = 0;
        for (var userEntry in currentReadBy) {
          totalRating += userEntry['rating'] as double;
        }
        double updatedRating = totalRating / currentReadBy.length;

        // Update the "rating" and "readBy" fields
        await ratingsDocRef.update({
          'rating': updatedRating,
          'readBy': currentReadBy, // Set "readBy" to the updated array of objects
        });

        print("Rating, readBy, and review updated successfully!");
      } else {
        // Document doesn't exist, create a new one
        await FirebaseFirestore.instance.collection("ratings").add({
          'bookId': bookId,
          'rating': newRating,
          'readBy': [
            {
              'uid': uid,
              'name': FirebaseAuth.instance.currentUser?.displayName,
              'rating': newRating,
              'comment': reviewText,
            },
          ], // Initialize "readBy" with an array containing user's information
        });
        print("New document created in 'ratings' collection.");
      }

      // Fetch the updated specific book rating and readBy count
      await fetchSpecificBookRating();
    } catch (e) {
      print("Error updating rating, readBy, and review: $e");
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
          .where('bookId', isEqualTo: widget.bookId);

      final specificBookSnapshot = await specificBookQuery.get();

      if (specificBookSnapshot.docs.isNotEmpty) {
        final specificBookData = specificBookSnapshot.docs.first.data() as Map<String, dynamic>;
        final specificBookRating = specificBookData['rating'];
        final specificBookReadBy = (specificBookData['readBy'] as List<dynamic>).cast<String>();

        // Check if the rating is an integer and convert it to a double
        if (specificBookRating is int) {
          setState(() {
            userRating = specificBookRating.toDouble();
            print(userRating);
            readByCount = specificBookReadBy.length;
          });
        } else if (specificBookRating is double) {
          setState(() {
            userRating = specificBookRating;
            readByCount = specificBookReadBy.length;
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
          .where('bookId', isEqualTo: widget.bookId);

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
  bool wishListBool = false;

  getWishListBool() {
    FirebaseFirestore.instance
        .collection("users")
        .doc('VkMhC98aY4zy2LlS948V')
        .collection("wishList")
    // .doc("wishlistId")
        .doc(widget.bookId)
        .get()
        .then((value) => {
      if (this.mounted)
        {
          if (value.exists)
            {
              setState(
                    () {
                  wishListBool = value.get("wishlist");
                },
              ),
            }
        }
    });
  }
  @override
  void initState() {
    super.initState();

    // Set initial values while waiting for data// You can set it to any default value you prefer
    getWishListBool();
    // Fetch the specific book rating when the page is initialized
    fetchSpecificBookRating();

    // Fetch the average book rating when the page is initialized
    fetchBookRating();
  }


  @override
  Widget build(BuildContext context) {
    userModel = context.watch<DbProvider>().userModel;
    WishListProvider wishListProvider = Provider.of(context);
    Color primaryColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? primaryColorDark
        : primaryColorLight;

    Color secondarycolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? secondaryColorDark
        : secondaryColorLight;

    Color tertiarycolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? tertiaryColorDark
        : tertiaryColorLight;
    Color neutralcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? neutralColorDark
        : neutralColorLight;
    Color buttoncolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    Color dividercolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white30
        : Colors.black;
    Color bordercolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white30
        : Colors.black;
    Color borderColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white24
        : Colors.black;
    String id='${widget.id}';
    String title='${widget.title}';
    print(FirebaseAuth.instance.currentUser?.uid as String);
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
                  height: 220,
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
                    borderRadius: BorderRadius.circular(15), // Adjust the value as needed
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
                        wishListBool == false
                            ? Icons.favorite_outline
                            : Icons.favorite,
                        color: wishListBool ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          wishListBool = !wishListBool;
                        });
                        if (wishListBool == true) {
                          // Add item to the wishlist
                          wishListProvider.addWishListData(
                            wishlistId: widget.bookId,
                            wishlistImage: widget.url,
                            wishlistName: widget.title,
                            wishlistAuthor: widget.author,
                              userId:userModel?.userId as String
                          );
                        }else{
                          wishListProvider.deleteWishList(widget.bookId,userModel?.userId as String);
                        }
                      },
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
                      onPressed: () async {
                        Share.share(BookPage(url: widget.url, bookId: widget.bookId) as String);
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
                            return isRatingUpdateInProgress
                                ? CircularProgressIndicator() // Show loading indicator
                                : AlertDialog(
                              title: Text("Read it? Then please rate it"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RatingBar.builder(
                                    initialRating: storedRating, // Use the storedRating variable
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
                                      // Only update the storedRating variable when the user interacts with the rating builder
                                      setState(() {
                                        storedRating = newRating;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 16.0), // Add spacing
                                  TextFormField(
                                    controller: review,
                                    maxLines: 5,
                                    maxLength: 150, // Set the maximum character limit
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8.0),
                                      hintText: "Enter your Review",
                                      border: OutlineInputBorder(), // Add border
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue), // Border color when focused
                                      ), // Display character count
                                    ),
                                  ),
                                  SizedBox(height: 16.0), // Add spacing
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (isRatingUpdateInProgress) {
                                        return; // Prevent rating update while in progress
                                      }

                                      // Set the flag to indicate that the rating update is in progress
                                      setState(() {
                                        isRatingUpdateInProgress = true;
                                      });

                                      // Handle the submit action here
                                      Navigator.of(context).pop(); // Close the dialog

                                      // Use the captured bookId to update the rating and review in Firestore
                                      await updateRatingAndReadByInFirestore(
                                        storedRating, // Use the storedRating value
                                        widget.bookId,
                                        userModel?.userId as String,
                                        review.text.trim(),
                                      );

                                      // Set the flag to indicate that the rating update is complete
                                      setState(() {
                                        isRatingUpdateInProgress = false;
                                      });
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
            SizedBox(height: 5,),
            Divider(),
            SizedBox(height: 10,),
            Container(
              height: 160,
              child: Column(
                children: [
                  Text(
                    "Reviews",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 100,
                    child: Divider(),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("ratings")
                          .where('bookId', isEqualTo: widget.bookId) // Replace with the actual document ID
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text('No reviews yet. Be the first one to review it'),
                          );
                        }

                        final readByList = snapshot.data!.docs
                            .map((document) {
                          final documentData = document.data() as Map<String, dynamic>?;

                          final readByData = (documentData != null && documentData.containsKey('readBy'))
                              ? (documentData['readBy'] as List?)?.cast<Map<String, dynamic>>()
                              : null;
                          return readByData?.cast<Map<String, dynamic>>();
                        })
                            .toList();

                        // Check if there are any non-empty comments
                        final hasNonEmptyComments = readByList.any((reviews) =>
                            reviews!.any((review) => (review['comment'] as String).isNotEmpty));

                        if (!hasNonEmptyComments) {
                          return Center(
                            child: Text('No reviews yet.'),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: readByList.length > 15 ? 15 : readByList.length, // Display only the first 15 snapshots
                          itemBuilder: (context, index) {
                            final reviews = readByList[index] as List<Map<String, dynamic>>;

                            return Padding(
                              padding: EdgeInsets.only(right: 8.0), // Add spacing between containers
                              child: Row(
                                children: reviews.map((review) {
                                  final name = review['name'] as String;
                                  final comment = review['comment'] as String;
                                  final rating = review['rating'] as double;

                                  if (comment.isEmpty) {
                                    // Skip reviews with an empty 'comment' field
                                    return Container();
                                  }

                                  return Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(10.0),
                                        height: 140,
                                        width: 240,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // SizedBox(height: 1,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 160,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 5,),
                                                      Text(name, style: TextStyle(fontWeight: FontWeight.bold,),textAlign: TextAlign.start,),
                                                    ],
                                                  ),
                                                ),
                                                Icon(Icons.star, color: Colors.amber,),
                                                Text(' $rating', style: TextStyle(fontWeight: FontWeight.bold,),textAlign: TextAlign.end,),
                                              ],
                                            ),
                                            SizedBox(height: 8.0),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  comment,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 12.0),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5,)
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3),
            Divider(),
            SizedBox(height: 5,),
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

                    return Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Similar Publications",style: TextStyle(fontWeight: FontWeight.bold),textAlign:TextAlign.center,),
                            Container(
                              width: 150,
                              child: Divider(),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                children: booksWithUrls.map<Widget>((bookDocument) {
                                  Map<String, dynamic> bookMap = bookDocument.data() as Map<String, dynamic>;
                                  String author = bookMap['author'];
                                  String secondtitle = bookMap['title'];
                                  String url = bookMap['url'];
                                  String bookId = bookMap['bookId'] ?? '';
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
                                                                title: secondtitle,
                                                                url: url,
                                                                id: widget.id,
                                                                bookId: bookId,
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
                                                        secondtitle,
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
                              )
                            ],
                          ),
                        )
                      ],
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
