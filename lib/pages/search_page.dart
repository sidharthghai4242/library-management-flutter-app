import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rlr/pages/book_page.dart';
import 'package:rlr/pages/all_books.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List searchResult = [];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection("Books")
        .where('bookTitleArray', arrayContains: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    });
  }

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
        title: const Text("Search Library"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search Here",
              ),
              onChanged: (query) {
                searchFromFirebase(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                final book = searchResult[index];
                final author = book['author'];
                final title = book['title'];
                final url = book['url'];
                final id = book['type']['catalogueId'];
                final DocId = book['docId'] ?? '';

                return FutureBuilder<double>(
                  future: fetchRatingByDocId(DocId),
                  builder: (context, ratingSnapshot) {
                    double bookRating = ratingSnapshot.data ?? 0.0;

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
                              DocId: DocId, // Corrected from 'id'
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        key: Key(DocId), // Added a key based on docId
                        leading: CachedNetworkImage(
                          imageUrl: url,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        title: Text(title),
                        subtitle: Text(author),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}