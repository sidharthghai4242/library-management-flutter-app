
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rlr/pages/general_book_page_screens/book_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List searchResult = [];
  TextEditingController searchcontroller = TextEditingController();
  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection("Books")
        .where('bookTitleArray', arrayContains: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    });
  }

  Future<double> fetchRatingBybookId(String bookId) async {
    final ratingQuerySnapshot = await FirebaseFirestore.instance
        .collection("ratings")
        .where('bookId', isEqualTo: bookId)
        .get();

    if (ratingQuerySnapshot.docs.isNotEmpty) {
      final ratingData = ratingQuerySnapshot.docs.first.data() as Map<String, dynamic>;
      return ratingData['rating']?.toDouble() ?? 0.0;
    }

    return 0.0; // Default rating if not found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        height: MediaQuery.of(context).size.height-76.260 ,
        color:Color(0xFF111111) ,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:40),
              Padding(
                padding: const EdgeInsets.all(15.0),

                child: TextFormField(
                  controller: searchcontroller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white), // Set the label text color here
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(100),// Set the border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    prefixIcon: Icon(CupertinoIcons.search),

                    prefixIconColor: Color(0xFFFFFFFF),
                    labelText: "Search Here",
                  ),
                  onChanged: (query) {
                    searchFromFirebase(query);
                  },
                ),
              ),

              if(searchcontroller.text.isEmpty)...[
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left:10,right:10,bottom:10,top:5
                        ),
                        height: MediaQuery.of(context).size.height-176.260 ,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("ratings")
                              .orderBy("rating", descending: true)
                              .limit(10)
                              .snapshots(),
                          builder: (context, ratingSnapshot) {
                            if (ratingSnapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading"); // Show loading indicator
                            }

                            final topRatedBooks = ratingSnapshot.data!.docs;

                            return ListView.builder(
                              itemCount: topRatedBooks.length + 1, // Add 1 for the "Top Searches" text
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // This is the "Top Searches" text
                                  return Text(
                                    "Top Rated Books",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white
                                    ),
                                  );
                                }

                                // Subtract 1 from index to get the correct book index
                                final ratingDoc = topRatedBooks[index - 1];
                                final bookId = (ratingDoc.data() as Map<String, dynamic>)['bookId'] as String;

                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection("Books")
                                      .doc(bookId)
                                      .get(),
                                  builder: (context, bookSnapshot) {
                                    if (bookSnapshot.connectionState == ConnectionState.waiting) {
                                      // Show loading indicator for individual books
                                      return Text("");
                                    }

                                    if (bookSnapshot.hasError) {
                                      return Text("Error: ${bookSnapshot.error}");
                                    }

                                    if (!bookSnapshot.hasData) {
                                      return Text("");
                                    }

                                    final bookData = bookSnapshot.data!.data() as Map<String, dynamic>;
                                    final author = bookData['author'] ?? "";
                                    print(author);
                                    final title = bookData['title'] ?? "";
                                    print(title);
                                    final url = bookData['url'] ?? "";
                                    final id = bookData['type']['catalogueId'] ?? "";

                                    return InkWell(
                                      onTap: () {
                                        // Navigate to the book page with details
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => BookPage(
                                              author: author,
                                              title: title,
                                              id: id,
                                              url: url,
                                              bookId: bookId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 8.0),
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [

                                                Container(
                                                  height:100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8), // Match the Container's border radius
                                                    child: CachedNetworkImage(
                                                      imageUrl: url,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context, url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 16.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width:200,
                                                        child: Text(
                                                          title,
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white
                                                          ),
                                                          textAlign: TextAlign.justify,
                                                        ),
                                                      ),
                                                      SizedBox(height: 2,),
                                                      Text(
                                                        author,
                                                        style: TextStyle(fontSize: 14.0, color: Colors.white70),
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        // ff
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          SizedBox(width: 90),
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          Text(
                                                            "${((ratingDoc.data() as Map<String, dynamic>)['rating'] as double).toStringAsFixed(1)}",
                                                            style: TextStyle(fontSize: 16.0, color: Colors.white),
                                                          ),
                                                          SizedBox(width: 10,)
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider( color: Colors.white),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
              if(searchcontroller.text.isNotEmpty)...[
                Container(
                  padding: EdgeInsets.only(
                      left:10,right:10,bottom:10,top:5
                  ),
                  height: MediaQuery.of(context).size.height-176.260 ,
                  child: ListView.builder(
                    itemCount: searchResult.length,
                    itemBuilder: (context, index) {
                      final book = searchResult[index];
                      final author = book['author'];
                      final title = book['title'];
                      final url = book['url'];
                      final id = book['type']['catalogueId'];
                      final bookId = book['bookId'] ?? '';
                      print(author);
                      print(title);print(url);print(id);print(bookId);


                      return FutureBuilder<double>(
                        future: fetchRatingBybookId(bookId),
                        builder: (context, ratingSnapshot) {
                          double bookRating = ratingSnapshot.data ?? 0.0;
                          String ratingString = bookRating.toStringAsFixed(1); // Adjust the number of decimal places as needed
                          return InkWell(
                            onTap: () {
                              // Navigate to the book page with details
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookPage(
                                    author: author,
                                    title: title,
                                    id: id,
                                    url: url,
                                    bookId: bookId, // Corrected from 'id'
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.only(
                                  left:15,
                                  right: 15,
                                  top:8,
                                  bottom: 8
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8.0), // Adjust margin as needed
                                    padding: EdgeInsets.all(8.0), // Adjust padding as needed
                                    child: Row(
                                      children: [
                                        Container(
                                          height:100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: url,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16.0), // Add spacing between image and text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width:200,
                                                child: Text(
                                                  title,
                                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.justify,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 2,),
                                              Text(
                                                author,
                                                style: TextStyle(fontSize: 14.0,color: Colors.white70),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Icon(Icons.star,color: Colors.amber,),
                                                  Text(
                                                    ratingString,
                                                    // textAlign: TextAlign.end,
                                                    style: TextStyle(fontSize: 16.0,color: Colors.white),
                                                  ),
                                                  SizedBox(width: 10,)
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(color: Colors.white), // Add a divider
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}