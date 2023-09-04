import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rlr/pages/book_page.dart';
import 'package:rlr/pages/catalogue_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  fetchCatalogue() {
    return FirebaseFirestore.instance.collection("Catalogue").snapshots();
  }

  fetchBooksByName(String value) {
    return FirebaseFirestore.instance.collection("Books")
        .where('type.catalogueId', isEqualTo: value)
        .snapshots();
  }

  // Function to fetch the rating based on DocId from the "ratings" collection
  Future<double> fetchRatingByDocId(String docId) async {
    final ratingQuerySnapshot = await FirebaseFirestore.instance
        .collection("ratings")
        .where('docId', isEqualTo: docId)
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
      appBar: AppBar(
        title: Text(
          'Read Ludhiana Read',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            icon: Icon(CupertinoIcons.bell_fill),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: fetchCatalogue(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                padding: EdgeInsets.all(18),
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> map =
                    snapshot.data.docs[index].data() as Map<String, dynamic>;
                    String name = map['name'].toString();
                    String id = map['catalogueId'].toString();
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CataloguePage(name: name, id: id),
                              ),
                            );
                          },
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(180),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(180),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(map['name'].toString()),
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
                  },
                ),
              );
            },
          ),
          StreamBuilder(
            stream: fetchCatalogue(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> map =
                    snapshot.data.docs[index].data() as Map<String, dynamic>;
                    String value = map['name'].toString();
                    String id = map['catalogueId'].toString();
                    String name = map['name'].toString();
                    return StreamBuilder(
                      stream: fetchBooksByName(id),
                      builder: (BuildContext context, AsyncSnapshot booksSnapshot) {
                        if (booksSnapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(); // Hide the category until data is fetched
                        }

                        // Filter out books with null 'url'
                        final booksWithUrls = booksSnapshot.data.docs.where((bookDocument) {
                          Map<String, dynamic> bookMap = bookDocument.data() as Map<String, dynamic>;
                          String url = bookMap['url'];
                          return url != null;
                        }).toList();

                        // Don't display the category if no books are found
                        if (booksWithUrls.isEmpty) {
                          return SizedBox();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("$value"),
                                  Container(
                                    width: value.length * 8, // Specify the width you want
                                    child: Divider(),
                                  ),
                                  Container(
                                    height: 265,
                                    padding: EdgeInsets.all(4),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: booksWithUrls.map<Widget>((bookDocument) {
                                          Map<String, dynamic> bookMap = bookDocument.data() as Map<String, dynamic>;
                                          String author = bookMap['author'];
                                          String title = bookMap['title'];
                                          String url = bookMap['url'];
                                          String docId = bookMap['docId'] ?? '';
                                          return FutureBuilder<double>(
                                            future: fetchRatingByDocId(docId),
                                            builder: (context, ratingSnapshot) {
                                              double bookRating = ratingSnapshot.data ?? 0.0;

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
                                                                      id: id,
                                                                      DocId: docId,
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
                                                            padding: EdgeInsets.symmetric(horizontal: 4),
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Container(
                                                                    child: Text(
                                                                      title,
                                                                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 2,
                                                                    ),
                                                                  ),
                                                                ),

                                                                if (bookRating != null) ...[
                                                                  SizedBox(width: 10,),
                                                                  Text(bookRating.toStringAsFixed(1)), // Display rating with 1 decimal place
                                                                  Icon(Icons.star),

                                                                ],
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
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
