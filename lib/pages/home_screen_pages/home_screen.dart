import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:rlr/pages/home_screen_pages/all_books.dart';
import 'package:rlr/pages/general_book_page_screens/book_page.dart';
import 'package:rlr/pages/home_screen_pages/catalogue_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/DbProvider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final navigatorKey = GlobalKey<NavigatorState>();
  bool shouldRefreshRatings = false;
  int issuedBooks = 0;
  bool isCategoryDropdownOpen = false;
  bool datafetched = false;
  List<String> titles = [];
  UserModel? userModel;
  double currentProgress = 0.5;
  Color primaryColorLight = Colors.white; // Soft sky blue// Soft pastel blue
  Color secondaryColorLight = Color(0xFF990000); // Bright orange
  Color tertiaryColorLight = Color(0xFF3E2723);
  Color neutralColorLight=Color(0xFF0A1746);// Dark chocolate brown
  Color primaryColorDark = Color(0xFF000000); // Midnight blue
  Color secondaryColorDark = Colors.deepPurple; // Electric purple// You can also use Colors.purpleAccent.
  Color tertiaryColorDark = Color(0xFFE900FF);
  Color neutralColorDark=Color(0xFFFFC600);
  String minimumPriceAsString ="";
  // Charcoal gray for text.

  TextStyle customTextStyle = GoogleFonts.robotoSlab(
    fontSize: 20,
   fontWeight: FontWeight.bold,
    color: Color(0xFFFFD700),
    shadows: [
      Shadow(
        blurRadius: 5,
        color: Colors.black, // Red text shadow
        offset: Offset(0, 2),
      ),
    ],
  );
  TextStyle customextStyle = GoogleFonts.robotoSlab(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFD700),
    shadows: [
      Shadow(
        blurRadius: 5,
        color: Colors.black, // Red text shadow
        offset: Offset(0, 2),
      ),
    ],
  );
  @override
  void initState(){
    fetchMinimumPriceAsString();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchBanners() {
    return FirebaseFirestore.instance.collection("Banners").snapshots();
  }

  void toggleCategoryDropdown() {
    setState(() {
      isCategoryDropdownOpen = !isCategoryDropdownOpen;
    });
  }
  Future<String> fetchMinimumPriceAsString() async {
    int minimumPrice = 10000000; // Initialize with a large value

    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Subscriptions').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          int price = document['price'] as int;
          print(price);
          if (price < minimumPrice) {
            minimumPrice = price;
          }
        }
      }
      setState(() {

      });
    } catch (e) {
      print('Error fetching data: $e');
    }

    // Convert the minimumPrice to a string
    minimumPriceAsString = minimumPrice.toString();

    return minimumPriceAsString;
  }

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

  void refreshRatings() {

    setState(() {
      shouldRefreshRatings = false; // Reset the flag
    });
  }

  fetchCatalogue() {
    return FirebaseFirestore.instance.collection("Catalogue").snapshots();
  }
  fetchCatalogueordered() {
    return FirebaseFirestore.instance.collection("Catalogue").orderBy('name').snapshots();
  }


  fetchBooksByName(String value) {
    return FirebaseFirestore.instance
        .collection("Books")
        .where('type.catalogueId', isEqualTo: value)
        .snapshots();
  }

  showCategoriesPopup(BuildContext context, List<DocumentSnapshot> data) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // double heightofbookbox = MediaQuery.of(context).size.height*0.43;
        // double heightofimageinbookbox= heightofbookbox*0.6;
        double screenwidth = MediaQuery.of(context).size.width;
        double widthOfBookBox= screenwidth * 0.8;
        if (widthOfBookBox > 300) {
          widthOfBookBox = 400;
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background with some transparency
            Container(
              color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
            ),
            // Popup content
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width:  widthOfBookBox,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Categories",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          // color: Colors.pink
                        ),
                    ),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF111111),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0), // Adjust the radius as needed
                            ),// Set your desired button color here
                          ),
                          child: Text(
                            name,
                            style: TextStyle(color: Colors.white),
                          ),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF111111),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0), // Adjust the radius as needed
                        ),// Set your desired button color here
                      ),
                      child: Text(
                        "All",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      shape: CircleBorder(),
                      fillColor: Colors.black.withOpacity(0.8),
                      // Change the button background color as needed
                      elevation: 0,
                      // No elevation
                      constraints: BoxConstraints(
                        minWidth: 36.0, // Adjust the size as needed
                        minHeight: 36.0, // Adjust the size as needed
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white, // Change the icon color as needed
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
    userModel = context.watch<DbProvider>().userModel;
    Color secondaryColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.white;

    Color tertiarycolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.grey
        : Colors.grey;

    Color buttoncolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.white;
    Color bordercolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white30
        :Colors.white30;

    // (kIsWeb ? screenwidth *0.9:MediaQuery.of(context).size.height*0.43)


    double screenwidth = MediaQuery.of(context).size.width;
    double widthOfBookBox= screenwidth * 0.42;
    if (widthOfBookBox > 300) {
      widthOfBookBox = 200;
    }
    double heightofbookbox = (kIsWeb ? screenwidth *0.25:MediaQuery.of(context).size.height*0.43);
    double heightofimageinbookbox= (kIsWeb ? heightofbookbox*0.67:heightofbookbox*0.6);
    double heightofbannerbox=(kIsWeb?heightofbookbox:heightofbookbox*0.6);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color:Color(0xFF111111)
            ),
            // color: primaryColor,
            height: MediaQuery.of(context).size.height-76.260 ,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Row(
                  children: [
                    // Enhancing the Image Container
                    Container(
                      height: 67,
                      child: Image.asset(
                        MediaQuery.of(context).platformBrightness == Brightness.dark
                            ? 'assets/rlrblack.jpg'
                            : 'assets/rlrblack.jpg',
                      ),
                    ),
                    // Enhancing the Membership Container
                   if(userModel!.subscription.name.isNotEmpty)...[
                     Container(
                       padding: EdgeInsets.all(6),
                       height: 55,
                       width: 120,
                       decoration: BoxDecoration(
                         // border: Border.all(
                         //   color: Colors.amber,
                         // ),
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Row(
                         children: [
                           Column(
                             children: [
                               Text("|",style: TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.w100),),
                             ],
                           ),
                           SizedBox(
                             width: 8, // Increased spacing for better alignment
                           ),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               GradientText(
                                 userModel!.subscription.name,
                                 style: TextStyle(
                                   fontWeight: FontWeight.bold, // Added bold font
                                 ), colors: [
                                   Color(0xFFEDEADE),Color(0xFFFFF5EE)
                               ],
                               ),
                               if(kIsWeb)...[
                                 GradientText(
                                   "Member",
                                   style: TextStyle(
                                   ), colors: [
                                   Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFFE1C16E),
                                 ],
                                 ),
                               ]else...[
                                 GradientText(
                                   "Membership",
                                   style: TextStyle(
                                   ), colors: [
                                   Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFFE1C16E),
                                 ],
                                 ),
                               ]
                             ],
                           )
                         ],
                       ),
                     ),
                   ],
                    Spacer(), // This pushes the icons to the end of the row
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/wishlist');
                      },
                      child: Icon(
                        CupertinoIcons.heart,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15), // Increased spacing for better alignment
                    // Enhancing the Bell Icon
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/notifications');
                      },
                      child: Icon(
                        color:Colors.white,
                        CupertinoIcons.bell,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 15), // Increased spacing for better alignment
                  ],
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder(
                        stream: fetchCatalogue(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1), // Adjust padding as needed
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (int index = 0;
                                        index < 2 && index < snapshot.data.docs.length;
                                        index++)
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
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25.0), // Adjust the radius as needed
                                                  ),// Set your desired button color here
                                                ),
                                                child: Text(
                                                  snapshot.data.docs[index]['name'].toString(),
                                                  style: TextStyle(color: Color(0xFF111111),fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                            ],
                                          ),
                                        if (snapshot.data.docs.length > 2)
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: buttoncolor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0), // Adjust the radius as needed
                                              ),// Set your desired button color here
                                            ),
                                            onPressed: () {
                                              showCategoriesPopup(
                                                  context, snapshot.data.docs.sublist(2));
                                            },
                                            label: Text(
                                              "Categories",
                                              style: TextStyle(
                                                  color: Colors.black,fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            icon: Icon(Icons.arrow_drop_down,
                                                color: Colors.black
                                            ),
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
                      Container(
                        height: heightofbannerbox,
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream:
                              fetchBanners(), // Replace with your actual stream
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            // Access the "title" field from each document in the snapshot
                            final titles = snapshot.data?.docs
                                .map((doc) => doc.data()['url'] as String)
                                .toList();
                            print(titles);
                            return Container(
                              height: heightofbannerbox,
                              width: MediaQuery.of(context).size.width,
                              padding:EdgeInsets.all(2),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: heightofbannerbox,
                                  autoPlay: true,
                                  enlargeCenterPage: true, // Set to true if you want the current image to be larger
                                  viewportFraction: 1.0, // Set to 1.0 to occupy the full width of the screen
                                ),
                                // kkk
                                items: titles?.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return InkWell(
                                        onTap: () async {
                                          const String url = 'https://www.instagram.com/read_ludhiana_read/?hl=en';
                                          if (await launch(url)) {
                                          } else {}
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                            4
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18), // Adjust the value as needed
                                            child: Container(
                                              decoration: BoxDecoration(
                                              ),
                                              width: MediaQuery.of(context).size.width,
                                              child: Image.network('$i', fit: BoxFit.cover),
                                            ),
                                          ),
                                        )
                                      );
                                    },
                                  );
                                }).toList(),
                              )
                            );
                          },
                        ),
                      ),
                     Container(
                       child: Column(
                         children: [
                           if(userModel!.subscription.name.isEmpty)...[
                             // SizedBox(height: 5,),
                             InkWell(
                               onTap:(){Navigator.pushNamed(context, '/membership');},
                               child: Container(
                                 height: 200,
                                 width: 300,
                                 child:  Stack(
                                   children: [
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         Container(
                                           width: 350, // Adjust the width and height as needed
                                           height: 150,
                                           decoration: BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors.black.withOpacity(0.8), // Set the shadow color and opacity
                                                 spreadRadius: 2, // Set the spread radius
                                                 blurRadius: 5, // Set the blur radius
                                                 offset: Offset(0, 2), // Set the shadow offset
                                               ),
                                             ],
                                             color: Colors.black,
                                             borderRadius: BorderRadius.circular(20.0),
                                             border: const GradientBoxBorder(
                                               gradient: LinearGradient(
                                                   begin: Alignment.bottomLeft,
                                                   colors: [Color(0xFF966919),Color(0xFF966919),Color(0xFFC19A6B),Color(0xFF966919),Color(0xFF966919),Color(0xFFC19A6B)]),
                                               width: 1,
                                             ),
                                           ),
                                           child: Column(
                                             children: [
                                               SizedBox(height:40),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: [
                                                   GradientText(
                                                     "₹"+minimumPriceAsString+"*",
                                                     textAlign: TextAlign.start,
                                                     style: TextStyle(
                                                       fontSize: 32,
                                                     ), colors: [
                                                     // if(MediaQuery.of(context).platformBrightness == Brightness.dark)...[
                                                     Color(0xFFE1C16E),Color(0xFFfffdd0)
                                                     // ]else...[
                                                     //   Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFFE1C16E),
                                                     // ]
                                                   ],
                                                   ),
                                                   Column(
                                                     children: [
                                                       Container(
                                                         height: 20,
                                                       ),
                                                       Text("for 1 month", style: TextStyle(color: Colors.white),textAlign: TextAlign.end,),
                                                     ],
                                                   )
                                                 ],
                                               ),
                                               SizedBox(height:10),
                                               Container(
                                                 width: 280,
                                                 height:45,
                                                 padding:  EdgeInsets.all(8),
                                                 decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(10),
                                                     gradient: LinearGradient(
                                                         colors:  [Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFF966919)]
                                                     ),
                                                     border: Border.all(
                                                         color: Colors.black
                                                     )
                                                 ),
                                                 child: Text("Join Now",style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,),
                                               )
                                             ],
                                           ),
                                         ),
                                       ],
                                     ),
                                     Column(
                                       children: [
                                         SizedBox(height: 2,),
                                         Row(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Column(
                                               children: [
                                                 SizedBox(height: 4.5,),
                                                 Container(
                                                   decoration: BoxDecoration(
                                                     color: Colors.black,
                                                     borderRadius: BorderRadius.circular(60.0),
                                                     gradient: LinearGradient(
                                                         colors: [
                                                           // if(MediaQuery.of(context).platformBrightness == Brightness.dark)...[
                                                           Color(0xFFE1C16E),Color(0xFF966919)
                                                           // ]else...[
                                                           //   Color(0xFFE1C16E),Color(0xFF966919)
                                                           // ]
                                                         ]
                                                     ),
                                                     border: Border.all(
                                                       width: 2.0, // Adjust the border width as needed
                                                       color: Colors.black38, // Adjust the border color as needed
                                                     ),
                                                   ),
                                                   height: 40,
                                                   width: 140,
                                                   child:Column(
                                                     crossAxisAlignment: CrossAxisAlignment.center,
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Text("Become a member",textAlign: TextAlign.center,style: TextStyle(
                                                           fontWeight: FontWeight.bold,
                                                           fontSize: 14,
                                                           color: Colors.white
                                                       ),)
                                                     ],
                                                   ),
                                                 )
                                               ],
                                             )
                                           ],
                                         )
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                             )

                           ],
                           SizedBox(height: 10,),
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text("EXPLORE LIBRARY",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: secondaryColor),),
                             ],
                           ),
                           Container(
                               width:200,
                               child:Divider(color:tertiarycolor)
                           ),
                           SizedBox(height: 7,),
                           StreamBuilder(
                             stream: fetchCatalogueordered(), // Stream for fetching data
                             builder:
                                 (BuildContext context, AsyncSnapshot snapshot) {
                               if (snapshot.connectionState ==
                                   ConnectionState.waiting) {
                                 return CircularProgressIndicator();
                               }
                               return CustomScrollView(
                                 shrinkWrap: true, // Add this line
                                 physics:
                                 NeverScrollableScrollPhysics(), // Add this line
                                 slivers: <Widget>[
                                   SliverList(
                                     delegate: SliverChildBuilderDelegate(
                                           (BuildContext context, int index) {
                                         Map<String, dynamic> map =
                                         snapshot.data.docs[index].data()
                                         as Map<String, dynamic>;
                                         String cataloguetitle =
                                         map['name'].toString();
                                         String id = map['catalogueId'].toString();
                                         return StreamBuilder(
                                           stream: fetchBooksByName(id),
                                           builder: (BuildContext context,
                                               AsyncSnapshot booksSnapshot) {
                                             if (booksSnapshot.connectionState ==
                                                 ConnectionState.waiting) {
                                               return SizedBox(); // Hide the category until data is fetched
                                             }

                                             final booksWithUrls = booksSnapshot
                                                 .data.docs
                                                 .where((bookDocument) {
                                               Map<String, dynamic> bookMap =
                                               bookDocument.data()
                                               as Map<String, dynamic>;
                                               String url = bookMap['url'];
                                               return url != null;
                                             }).toList();

                                             if (booksWithUrls.isEmpty) {
                                               return SizedBox();
                                             }

                                             return Column(
                                               crossAxisAlignment:
                                               CrossAxisAlignment.start,
                                               children: [
                                                 Container(
                                                   padding: EdgeInsets.all(10),
                                                   child: Column(
                                                     crossAxisAlignment:
                                                     CrossAxisAlignment.start,
                                                     children: [
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment.start,
                                                         children: [
                                                           SizedBox(width: 5,),
                                                           Column(
                                                             children: [
                                                               Text(
                                                                 cataloguetitle,
                                                                 style: TextStyle(
                                                                   fontWeight: FontWeight.bold,
                                                                   color: secondaryColor,
                                                                   fontSize: 18,
                                                                 ),
                                                               ),
                                                             ],
                                                           )
                                                         ],
                                                       ),

                                                       SizedBox(height: 5,),
                                                       Container(
                                                         color: Colors.transparent,
                                                         height: heightofbookbox+3,
                                                         padding: EdgeInsets.only(
                                                             top: 4,bottom: 4
                                                         ),
                                                         child:
                                                         SingleChildScrollView(
                                                           scrollDirection:
                                                           Axis.horizontal,
                                                           child: Row(
                                                             children: booksWithUrls
                                                                 .map<Widget>(
                                                                     (bookDocument) {
                                                                   Map<String, dynamic>
                                                                   bookMap =
                                                                   bookDocument
                                                                       .data()
                                                                   as Map<String,
                                                                       dynamic>;
                                                                   String author =
                                                                   bookMap['author'];
                                                                   String title =
                                                                   bookMap['title'];
                                                                   String url =
                                                                   bookMap['url'];
                                                                   String bookId =
                                                                       bookMap['bookId'] ??
                                                                           '';
                                                                   String catalogueId =
                                                                       bookMap['type'][
                                                                       'catalogueId'] ??
                                                                           '';

                                                                   return FutureBuilder<
                                                                       double>(
                                                                     future:
                                                                     fetchRatingBybookId(
                                                                         bookId),
                                                                     builder: (context,
                                                                         ratingSnapshot) {
                                                                       double
                                                                       bookRating =
                                                                           ratingSnapshot
                                                                               .data ??
                                                                               0.0;

                                                                       return Row(
                                                                         children: [
                                                                           ClipRRect(
                                                                             borderRadius:BorderRadius.circular(16),
                                                                             child: Material(
                                                                               child:
                                                                               Container(
                                                                                 height: heightofbookbox ,
                                                                                 padding:
                                                                                 EdgeInsets.all(
                                                                                     8),
                                                                                 decoration:
                                                                                 BoxDecoration(
                                                                                   borderRadius:
                                                                                   BorderRadius.circular(15),
                                                                                   border:
                                                                                   Border.all(
                                                                                     color: bordercolor,
                                                                                     width:
                                                                                     2,
                                                                                   ),
                                                                                 ),
                                                                                 width:
                                                                                 widthOfBookBox,
                                                                                 child:
                                                                                 Column(
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
                                                                             ),
                                                                           ),
                                                                           SizedBox(width: 8),
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
                                       childCount: snapshot.data.docs.length,
                                     ),
                                   ),
                                 ],
                               );
                             },
                           ),
                         ],
                       ),
                     )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}