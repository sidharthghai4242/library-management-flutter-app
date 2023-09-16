import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // List<Map<String, dynamic>> searchResults = [];

  // Future<void> searchFromFirebase(String query) async {
  //   final result = await FirebaseFirestore.instance
  //       .collection('Books')
  //       .where('author', isGreaterThanOrEqualTo: query)
  //       .where('author', arrayContains: query )
  //       .get();

  //   setState(() {
  //     searchResults = result.docs.map((e) => e.data()).toList();
  //   });
  // }
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
                return ListTile(
                  title: Text(searchResult[index]['title']),
                  subtitle: Text(searchResult[index]['author']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}