import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rlr/pages/book_page.dart';
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
                    return Row(children: [
                      InkWell(
                        onTap: (){

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

                      ),SizedBox(width: 10,)
                    ],);
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
                    String id=map['catalogueId'].toString();
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
                                width: value.length *8, // Specify the width you want
                                child: Divider(),
                              ),
                              Container(
                                child: StreamBuilder(
                                  stream: fetchBooksByName(id),
                                  builder: (BuildContext context, AsyncSnapshot booksSnapshot) {
                                    if (booksSnapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: booksSnapshot.data.docs.map<Widget>((bookDocument) {
                                          Map<String, dynamic> bookMap = bookDocument.data() as Map<String, dynamic>;
                                          String author=bookMap['author'];
                                          String title=bookMap['title'];
                                          String url=bookMap['url'];
                                          return Row(
                                            children: [
                                              Material(
                                                elevation: 5,
                                                borderRadius: BorderRadius.circular(10),
                                                child: Container(
                                                  height: 200,
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (context) => BookPage(author:author,title:title,url:url),)
                                                      );
                                                    },
                                                    child: Image.network(bookMap['url']),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15,)
                                            ],
                                          );

                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(height: 10),
                            ],
                          ),
                        ) // Add some spacing between items
                      ],
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
