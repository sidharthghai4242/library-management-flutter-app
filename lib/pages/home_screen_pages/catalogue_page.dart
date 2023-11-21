import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rlr/pages/general_book_page_screens/book_page.dart';

class CataloguePage extends StatefulWidget {
  final String name;
  final String id;

  CataloguePage({required this.name, required this.id});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  Future<double> fetchRatingBybookId(String bookId) async {
    final ratingQuerySnapshot = await FirebaseFirestore.instance
        .collection("ratings")
        .where('bookId', isEqualTo: bookId)
        .get();

    if (ratingQuerySnapshot.docs.isNotEmpty) {
      final ratingData =
      ratingQuerySnapshot.docs.first.data() as Map<String, dynamic>;
      return ratingData['rating']?.toDouble() ?? 0.0;
    }

    return 0.0; // Default rating if not found
  }

  Stream<QuerySnapshot> fetchBooksByName(String value) {
    return FirebaseFirestore.instance
        .collection("Books")
        .where('type.catalogueId', isEqualTo: value)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double gridwidth=(kIsWeb? screenwidth*0.56: screenwidth);
    double heightofbookbox = (kIsWeb ? screenwidth *0.27:MediaQuery.of(context).size.height*0.43);
    double heightofimageinbookbox= (kIsWeb ? heightofbookbox*0.68:heightofbookbox*0.6);
    double widthOfBookBox= screenwidth * 0.42;
    if (widthOfBookBox > 300) {
      widthOfBookBox = 200;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.name}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF111111),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Color(0xFF111111),
        child: StreamBuilder<QuerySnapshot>(
          stream: fetchBooksByName(widget.id),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> booksSnapshot) {
            if (booksSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            if (!booksSnapshot.hasData || booksSnapshot.data == null) {
              return Center(
                child: Text("No books found."),
              );
            }

            // Extract the list of documents
            final bookDocuments = booksSnapshot.data!.docs;

            return Container(
              width: screenwidth,
              color: Color(0xFF111111),
              child: Center(
                child: Container(
                  width:  gridwidth,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: (kIsWeb ? 4:2), // 2 columns
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: (kIsWeb ? 0.5:0.5),
                              ),
                              delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  // Access the book data
                                  Map<String, dynamic>? bookMap =
                                  bookDocuments[index].data() as Map<String, dynamic>?;

                                  if (bookMap == null) {
                                    return Container(); // Handle null bookMap
                                  }

                                  String author = bookMap['author'] ?? "Unknown Author";
                                  String title = bookMap['title'] ?? "Unknown Title";
                                  String url = bookMap['url'] ?? "https://example.com/default-image.jpg";
                                  String bookId = bookMap['bookId'] ?? '';
                                  String catalogueId= bookMap['type']['catalogueId'] ??'';

                                  return FutureBuilder<double>(
                                    future: fetchRatingBybookId(bookId),
                                    builder: (context, ratingSnapshot) {
                                      double bookRating = ratingSnapshot.data ?? 0.0;

                                      return Material(
                                        elevation: 2, // Add elevation for a shadow effect
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Color(0xFF111111)), // Add border for separation
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height:
                                                heightofimageinbookbox,
                                                width:widthOfBookBox*0.9,
                                                child:
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) => BookPage(
                                                          author: author,
                                                          title: title,
                                                          url: url,
                                                          id: catalogueId,
                                                          bookId: bookId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child: Image.network(
                                                      url,
                                                      fit:BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Center(child:Text('Unable to load image from server'));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6,),
                                              Container(
                                                width:widthOfBookBox,
                                                padding:
                                                EdgeInsets.only(
                                                    top: 4
                                                ),
                                                child:
                                                Column(
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
                                                        // color: Colors.grey,
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
                                      );
                                    },
                                  );
                                },
                                childCount: bookDocuments.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
