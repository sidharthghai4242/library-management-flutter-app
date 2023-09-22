import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({Key? key}) : super(key: key);

  @override
  State<MyBooks> createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Books'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('issuedBooks')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No books have been issued 😢', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                   // Replace with your crying emoji asset
                ],
              ),
            );
          }

          // Create a list to store the docIds
          List<String> docIds = snapshot.data!.docs
              .map((DocumentSnapshot document) => document.id)
              .toList();

          // Fetch books based on the docIds
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Books')
                .where('docId', whereIn: docIds) // Filter by docIds
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> bookSnapshot) {
              if (bookSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!bookSnapshot.hasData || bookSnapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No books found 😢', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      // Replace with your crying emoji asset
                    ],
                  ),
                );
              }

              return ListView(
                children: bookSnapshot.data!.docs.map((DocumentSnapshot bookDocument) {
                  Map<String, dynamic> bookData =
                  bookDocument.data() as Map<String, dynamic>;
                  String bookTitle = bookData['title'];
                  String author = bookData['author'];
                  String issueDate = bookData['issueDate'];

                  return ListTile(
                    title: Text(bookTitle),
                    subtitle: Text('Author: $author\nIssued on: $issueDate'),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
