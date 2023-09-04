import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rlr/pages/book_page.dart';

class CataloguePage extends StatefulWidget {
  String name;
  String id;
  CataloguePage({required this.name, required this.id});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
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

  fetchBooksByName(String value) {
    return FirebaseFirestore.instance
        .collection("Books")
        .where('type.catalogueId', isEqualTo: value)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.name}',
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
      ),
      body: StreamBuilder(
        stream: fetchBooksByName(widget.id),
        builder: (BuildContext context, AsyncSnapshot booksSnapshot) {
          if (booksSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!booksSnapshot.hasData || booksSnapshot.data == null) {
            return Center(
              child: Text("No books found."),
            );
          }

          // Extract the list of documents
          final bookDocuments = booksSnapshot.data.docs;

          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 columns
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.75,
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
                            String docId = bookMap['docId'] ?? '';

                            return FutureBuilder<double>(
                              future: fetchRatingByDocId(docId),
                              builder: (context, ratingSnapshot) {
                                double bookRating = ratingSnapshot.data ?? 0.0;

                                return Material(
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
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
          );
        },
      ),
    );
  }
}
