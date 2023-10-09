
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rlr/pages/book_page.dart';
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
          "Explore Library",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Color(0xFF9B442B), // Change the background color as desired
        centerTitle: true, // Center-align the title
        elevation: 0, // Remove the shadow
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list), // You can replace this with your desired icon
            onPressed: () {
              // Add your filter action here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: searchcontroller,
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  // prefixIconColor: Color(0xFF3B0900),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      // color: Color(0xFF9B442B),
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
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
                      padding: EdgeInsets.all(10),
                      height: 492,
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
                                  "Top Searches",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                );
                              }

                              // Subtract 1 from index to get the correct book index
                              final ratingDoc = topRatedBooks[index - 1];
                              final docId = (ratingDoc.data() as Map<String, dynamic>)['docId'] as String;

                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("Books")
                                    .doc(docId)
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
                                  final title = bookData['title'] ?? "";
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
                                            DocId: docId,
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
                                                    color: Colors.black,
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
                                                    Text(
                                                      title,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                    Text(
                                                      author,
                                                      style: TextStyle(fontSize: 14.0),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        SizedBox(width: 90),
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        Text(
                                                          "${(ratingDoc.data() as Map<String, dynamic>)['rating']}",
                                                          style: TextStyle(fontSize: 16.0),
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
                                        Divider(),
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
                height: 492,
                child: ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, index) {
                    final book = searchResult[index];
                    final author = book['author'];
                    final title = book['title'];
                    final url = book['url'];
                    final id = book['type']['catalogueId'];
                    final DocId = book['docId'] ?? '';
                    print(author);
                    print(title);print(url);print(id);print(DocId);


                    return FutureBuilder<double>(
                      future: fetchRatingByDocId(DocId),
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
                                  DocId: DocId, // Corrected from 'id'
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
                                              color: Colors.black,
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
                                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,),textAlign: TextAlign.justify,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 2,),
                                            Text(
                                              author,
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Icon(Icons.star,color: Colors.amber,),
                                                Text(
                                                  ratingString,
                                                  // textAlign: TextAlign.end,
                                                  style: TextStyle(fontSize: 16.0),
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
                                Divider(), // Add a divider
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
    );
  }
}