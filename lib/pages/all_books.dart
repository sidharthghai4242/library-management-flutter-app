import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rlr/pages/book_page.dart';

class Allbooks extends StatefulWidget {
  const Allbooks({Key? key});

  @override
  State<Allbooks> createState() => _AllbooksState();
}

class _AllbooksState extends State<Allbooks> {
  Future<double> fetchRatingBybookId(String bookId) async {
    try {
      final ratingQuery = await FirebaseFirestore.instance
          .collection("ratings")
          .where('bookId', isEqualTo: bookId)
          .get();

      if (ratingQuery.docs.isNotEmpty) {
        final ratingData = ratingQuery.docs.first.data() as Map<String, dynamic>;
        final rating = ratingData['rating'] as double;
        return rating;
      } else {
        return 0.0; // Return 0.0 if there are no ratings for the book
      }
    } catch (e) {
      print("Error fetching rating for bookId $bookId: $e");
      return 0.0; // Return 0.0 in case of an error
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Books',style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        elevation: 0,
        backgroundColor: Color(0xFF111111),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:Container(
        color: Color(0xFF111111),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Books").orderBy("title").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No books found.'),
                );
              }

              // Extract and display the list of books
              final bookDocuments = snapshot.data!.docs;

              return CustomScrollView(
                slivers: [
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.5,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        // Access the book data
                        Map<String, dynamic>? bookMap = bookDocuments[index].data() as Map<String, dynamic>?;

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
                                                id: catalogueId,
                                                bookId: bookId,
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
                            );
                          },
                        );
                      },
                      childCount: bookDocuments.length,
                    ),
                  ),
                ],
              );
            },
          ),),
      )
      
    );
  }
}
