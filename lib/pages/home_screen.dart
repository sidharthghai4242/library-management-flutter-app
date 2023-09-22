import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rlr/pages/all_books.dart';
import 'package:rlr/pages/book_page.dart';
import 'package:rlr/pages/catalogue_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final navigatorKey = GlobalKey<NavigatorState>();
  bool shouldRefreshRatings = false;
  bool isCategoryDropdownOpen = false;
  bool datafetched=false;
  void toggleCategoryDropdown() {
    setState(() {
      isCategoryDropdownOpen = !isCategoryDropdownOpen;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Add a listener to the Navigator to detect page transitions
    navigatorKey.currentState?.widget.observers.add(NavigatorObserver(this));
  }


  Future<double> fetchRatingByDocId(String docId) async {
    final ratingQuerySnapshot = await FirebaseFirestore.instance
        .collection("ratings")
        .where('docId', isEqualTo: docId)
        .get();

    if (ratingQuerySnapshot.docs.isNotEmpty) {
      final ratingData =
      ratingQuerySnapshot.docs.first.data() as Map<String, dynamic>;
      return ratingData['rating']?.toDouble() ?? 0.0;
    }

    return 0.0; // Default rating if not found
  }

  @override
  void didPush() {
    // This method is called when a new route has been pushed.
    // You can add additional logic here if needed.
  }

  @override
  void didPopNext() {
    // This method is called when the current route has been popped off,
    // and the previous route (i.e., the home page) is now visible again.
    // You can refresh ratings or perform any other necessary updates here.
    if (shouldRefreshRatings) {
      refreshRatings();
    }
  }

  // Function to refresh ratings
  void refreshRatings() {
    // Implement the logic to refresh ratings here
    // You may need to update the state of your widgets to reflect the changes
    setState(() {
      shouldRefreshRatings = false; // Reset the flag
    });
  }

  fetchCatalogue() {
    return FirebaseFirestore.instance.collection("Catalogue").snapshots();
  }

  fetchBooksByName(String value) {
    return FirebaseFirestore.instance.collection("Books")
        .where('type.catalogueId', isEqualTo: value)
        .snapshots();
  }
  showCategoriesPopup(BuildContext context, List<DocumentSnapshot> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background with some transparency
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            ),
            // Popup content
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Text("Categories",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.pink),),
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> map =
                        data[index].data() as Map<String, dynamic>;
                        String name = map['name'].toString();
                        String id = map['catalogueId'].toString();
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CataloguePage(name: name, id: id),
                              ),
                            );
                          },
                          child: Text(name,style: TextStyle(color: Colors.pinkAccent),),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Allbooks(),
                          ),
                        );
                      },
                      child: Text("All",style: TextStyle(color: Colors.pinkAccent),),
                    ),
                    SizedBox(height: 5,),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      shape: CircleBorder(),
                      fillColor: Colors.white, // Change the button background color as needed
                      elevation: 0, // No elevation
                      constraints: BoxConstraints(
                        minWidth: 36.0, // Adjust the size as needed
                        minHeight: 36.0, // Adjust the size as needed
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.black, // Change the icon color as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Color borderColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white24
        : Colors.black26;
    return
      // datafetched ?(Center(child: CircularProgressIndicator(),)):
    Scaffold(
      appBar: AppBar(
        title: Text(
          'Read Ludhiana Read',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.pink),
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
                padding: EdgeInsets.symmetric(horizontal: 8), // Adjust padding as needed
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int index = 0; index < 2 && index < snapshot.data.docs.length; index++)
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CataloguePage(
                                            name: snapshot.data.docs[index]['name'].toString(),
                                            id: snapshot.data.docs[index]['catalogueId'].toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(snapshot.data.docs[index]['name'].toString(),style: TextStyle(color:Colors.pinkAccent),),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            if (snapshot.data.docs.length > 2)
                              ElevatedButton.icon(
                                onPressed: () {
                                  showCategoriesPopup(context, snapshot.data.docs.sublist(2));
                                },
                                label: Text("Categories",style: TextStyle(color: Colors.pinkAccent),),
                                icon: Icon(Icons.arrow_drop_down,color: Colors.pinkAccent),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                        final booksWithUrls = booksSnapshot.data.docs
                            .where((bookDocument) {
                          Map<String, dynamic> bookMap =
                          bookDocument.data() as Map<String, dynamic>;
                          String url = bookMap['url'];
                          return url != null;
                        })
                            .toList();

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
                                  Text("$value",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Container(
                                    width: value.length *
                                        8, // Specify the width you want
                                    child: Divider(),
                                  ),
                                  Container(

                                    height: 320,
                                    padding: EdgeInsets.all(4),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: booksWithUrls
                                            .map<Widget>((bookDocument) {
                                          Map<String, dynamic> bookMap =
                                          bookDocument.data()
                                          as Map<String, dynamic>;
                                          String author = bookMap['author'];
                                          String title = bookMap['title'];
                                          String url = bookMap['url'];
                                          String docId = bookMap['docId'] ?? '';
                                          String catalogueId= bookMap['type']['catalogueId'] ??'';
                                          print(catalogueId);
                                          return FutureBuilder<double>(
                                            future: fetchRatingByDocId(docId),
                                            builder: (context, ratingSnapshot) {
                                              double bookRating = ratingSnapshot.data ?? 0.0;

                                              return Row(
                                                children: [
                                                  Material(
                                                    child: Container(
                                                      height:380,
                                                      padding: EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15), // Adjust the value as needed
                                                        border: Border.all(
                                                          color: borderColor, // Adjust the border color as needed
                                                          width: 2, // Adjust the border width as needed
                                                        ),
                                                      ),
                                                      width: 150, // Set a fixed width
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            height: 190,
                                                            child: InkWell(
                                                              onTap: () {
                                                                // Navigate to the book page with details
                                                                Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        BookPage(
                                                                          author: author,
                                                                          title: title,
                                                                          url: url,
                                                                          id: catalogueId,
                                                                          DocId: docId,
                                                                        ),
                                                                  ),
                                                                );
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15),
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
                                                  ),
                                                  SizedBox(width: 10,)

                                                ],
                                              );
                                            },
                                          );
                                        })
                                            .toList(),
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

class NavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  final _homeScreenState;

  NavigatorObserver(this._homeScreenState);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute is PageRoute && previousRoute.settings.name == '/') {
      // Detect when returning to the home page and set the refresh flag
      _homeScreenState.setState(() {
        _homeScreenState.shouldRefreshRatings = true;
      });
    }
  }
}
