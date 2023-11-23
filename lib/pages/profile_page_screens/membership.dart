import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';

import '../../provider/DbProvider.dart';
class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  FirebaseFirestore? firestore;
  UserModel? userModel;
  fetch() {
    // var uid = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot> stream =
    FirebaseFirestore.instance.collection("Subscriptions").snapshots();
    return stream;
  }

  @override
  Widget build(BuildContext context) {
    userModel = context.watch<DbProvider>().userModel;
    double screenwidth = MediaQuery.of(context).size.width;
    double widthOfBookBox= screenwidth;
    if (widthOfBookBox > 300) {
      widthOfBookBox = 500;
    }
    double heightofbookbox = (kIsWeb ? screenwidth *0.25:MediaQuery.of(context).size.height*0.43);
    double heightofimageinbookbox= (kIsWeb ? heightofbookbox*0.67:heightofbookbox*0.6);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Be a proud member....",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:Color(0xFF111111),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // color: Color(0xFF111111),
      body: Container(
        color: Color(0xFF111111),
        child: StreamBuilder(
          stream: fetch(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              padding: EdgeInsets.all(16),
              children: snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                Map<String, dynamic> map =
                document.data()! as Map<String, dynamic>;
                String title=map['name'].toString();
                return Column(
                  children: [
                    Card(
                      elevation: 6, // Increased elevation for a more pronounced shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white, // Set a light background color for the card
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: widthOfBookBox,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                map['name'].toString() + " Membership",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22, // Larger font size for the title
                                  color: Colors.black87, // Slightly darker text color
                                ),
                              ),
                              Divider(
                                color: Colors.black54, // Darker divider color
                                thickness: 1, // Increased thickness of the divider
                                height: 20, // Increased height of the divider
                              ),
                              SizedBox(height: 1),
                              if (map['descriptionTitle'] != null)
                                Text(
                                  map['descriptionTitle'].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.library_books,
                                    color: Color(0xFF111111),
                                    size: 24, // Larger icon size
                                  ),
                                  SizedBox(width: 12), // Increased spacing between icon and text
                                  Text(
                                    "Maximum Books: " + map['maxBooks'].toString(),
                                    style: TextStyle(
                                      fontSize: 18, // Slightly larger text size
                                      color: Colors.black87,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: Color(0xFF111111),
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Issue Period: " + map['issuePeriod'].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.money,
                                    color: Color(0xFF111111),
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Price: Rs. " + map['price'].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Color(0xFF111111),
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Validity: 30 Days",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Column(
                                  children: [
                                    if(userModel?.subscription.name==title)...[
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12, // Wider button
                                            vertical: 12,   // Taller button
                                          ),
                                          child:Column(
                                            children: [
                                              Text(
                                                "Already Joined",
                                                style: TextStyle(
                                                  fontSize: 18, // Larger text size
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                    if(userModel?.subscription.name!=title)...[
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12, // Wider button
                                            vertical: 12,   // Taller button
                                          ),
                                          child:Column(
                                            children: [
                                              Text(
                                                "Join Now",
                                                style: TextStyle(
                                                  fontSize: 18, // Larger text size
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24), // Increased spacing between cards
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
