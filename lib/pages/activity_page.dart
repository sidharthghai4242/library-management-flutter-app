import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';

import '../provider/DbProvider.dart';
class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userModel = context.watch<DbProvider>().userModel;
    String formattedJoinDate = userModel?.createdOn != null
        ? DateFormat('dd/MM/yyyy').format(userModel!.createdOn.toDate())
        : 'Loading...';
    // Color(0xFF111111)
    return Scaffold(
      body: Container(
        height: 700,
        color:Color(0xFF111111),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Colors.white
                              ),
                              child: Icon(Icons.timer_sharp,color: Colors.black87,),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              'Joined Date: $formattedJoinDate',
                              style: TextStyle(fontSize: 18,color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        FutureBuilder(
                          future: _fetchBookActivities(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("");
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<Map<String, dynamic>> bookActivities = snapshot.data ?? [];
                              return Container(
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (bookActivities.isNotEmpty)...[
                                      Text(
                                        'Book Activities:',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                                      ),
                                      SizedBox(height: 8),
                                      Column(
                                        children: [
                                          for (var book in bookActivities)
                                            Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 115,
                                                      width:38,
                                                      child: VerticalDivider(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top:30,
                                                      left:1,
                                                      child: Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(60),
                                                            color: Colors.white
                                                        ),
                                                        child: Icon(Icons.library_books_outlined,color: Colors.black87,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 20,),
                                                Container(
                                                  width:260,
                                                  child: Text(
                                                    '\n Title: ${book['title']},\n Issued Date: ${book['issueDate']} ${book['returnDate'] != null ? ",\n Return Date:" + book['returnDate']  : ''}\n',
                                                    style: TextStyle(fontSize: 16,color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          SizedBox(height: 20,),
                                          Center(
                                            child: Column(
                                              children: [
                                                Text("Issue more Books,",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                                Text("to continue your journey.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                              ],
                                            )
                                          )
                                        ],
                                      )
                                    ] else ...[
                                      Text(
                                        'No book activities available.',
                                        style: TextStyle(fontSize: 16,color: Colors.white),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchBookActivities() async {
    List<Map<String, dynamic>> bookActivities = [];

    if (userModel != null) {
      QuerySnapshot<Map<String, dynamic>> issuedBooksSnapshot =
      await FirebaseFirestore.instance
          .collection('users/${userModel!.authId}/issuedBooks')
          .orderBy('issueDate') // Sort by issueDate in ascending order
          .get();

      for (var doc in issuedBooksSnapshot.docs) {
        String title = doc['title'];
        DateTime issueDate = doc['issueDate'].toDate();
        DateTime? returnDate = doc['returnDate'] != null
            ? doc['returnDate'].toDate()
            : null;

        // Check if 'returnDate' field is present and not null in the document
        if (doc.data()!.containsKey('returnDate') && returnDate != null) {
          bookActivities.add({
            'title': title,
            'issueDate': DateFormat('dd/MM/yyyy').format(issueDate),
            'returnDate': DateFormat('dd/MM/yyyy').format(returnDate),
          });
        } else {
          bookActivities.add({
            'title': title,
            'issueDate': DateFormat('dd/MM/yyyy').format(issueDate),
          });
        }
      }
    }

    return bookActivities;
  }
}
