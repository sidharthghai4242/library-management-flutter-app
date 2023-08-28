import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rlr/models/UserModel.dart';
// class Membership extends StatefulWidget {
//   const Membership({super.key});
//   @override
//   State<Membership> createState() => _MembershipState();
// }
// final db = FirebaseFirestore.instance;
// class _MembershipState extends State<Membership> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
//   }
// //     return Scaffold(
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: Colors.white,
// //         centerTitle: true,
// //         title: Text(
// //           "Be a proud member....",
// //           textAlign: TextAlign.center,
// //           style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:Color.fromRGBO(0, 0, 128, 1)),
// //         ),
// //         leading: IconButton(
// //           onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
// //           icon: const Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 32,),
// //         ),
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           image: DecorationImage(
// //             image: AssetImage('assets/background_image.jpg'),
// //             opacity: 0.75,// Replace with your image asset path
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //         child: ListView(
// //           padding: const EdgeInsets.all(8),
// //           children: <Widget>[
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Card(
// //                   color: Color.fromRGBO(255,210,0, 1), // Setting the background color to golden
// //                   elevation: 8, // Adding a slight shadow
// //                   margin: EdgeInsets.all(16),
// //                   // Adding margin for spacing
// //                   child: Padding(
// //                     padding: EdgeInsets.all(16), // Adding padding within the card
// //                     child: Container(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           SizedBox(
// //                             height: 60,
// //                             width: 160,
// //                             child: Container(
// //                               margin: const EdgeInsets.only(top: 16),
// //                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                               width: MediaQuery.of(context).size.width,
// //                               decoration: BoxDecoration(
// //                                   color: Colors.black,
// //                                   borderRadius: BorderRadius.circular(8)
// //                               ),
// //                               child:Row(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 crossAxisAlignment: CrossAxisAlignment.center,
// //                                 children: [
// //                                   Text(
// //                                     "Rs. 499/ Month",
// //                                     textAlign: TextAlign.center,
// //                                     style: GoogleFonts.openSans(
// //                                         fontSize: 16,
// //                                         color: Colors.white,
// //                                         fontWeight: FontWeight.bold
// //                                     ),
// //                                   ),
// //                                   // const SizedBox(width: 4),
// //                                   // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
// //                                 ],
// //                               ),
// //                               // color: Colors.black,
// //                               // padding:EdgeInsets.all(10),
// //                               // child: const Text("Rs. 499/month",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16),),
// //                             ),
// //                           ),
// //                           SizedBox(height: 5,),
// //                           const Text("Gold Membership",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
// //                           Divider(color: Colors.black,),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Maximum Books:- 20",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Issue Period:- 45",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Validity:- 30 Days",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height:20,),
// //                           Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               InkWell(
// //                                 onTap: ()=>Navigator.pushReplacementNamed(context, '/home'),
// //                                 child: Container(
// //                                   margin: const EdgeInsets.only(top: 16),
// //                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                                   width: MediaQuery.of(context).size.width,
// //                                   decoration: BoxDecoration(
// //                                       color: Colors.black,
// //                                       borderRadius: BorderRadius.circular(8)
// //                                   ),
// //                                   child: Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     crossAxisAlignment: CrossAxisAlignment.center,
// //                                     children: [
// //                                       Text(
// //                                         "Pay Now",
// //                                         textAlign: TextAlign.center,
// //                                         style: GoogleFonts.openSans(
// //                                             fontSize: 16,
// //                                             color: Colors.white,
// //                                             fontWeight: FontWeight.bold
// //                                         ),
// //                                       ),
// //                                       // const SizedBox(width: 4),
// //                                       // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
// //                                     ],
// //                                   ),
// //                                 ),
// //                               )
// //                             ],
// //                           ),
// //
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Card(
// //                   color: Color.fromRGBO(188, 198, 235, 1), // Setting the background color to golden
// //                   elevation: 8, // Adding a slight shadow
// //                   margin: EdgeInsets.all(16), // Adding margin for spacing
// //                   child: Padding(
// //                     padding: EdgeInsets.all(16), // Adding padding within the card
// //                     child: Container(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           SizedBox(
// //                             height: 60,
// //                             width: 160,
// //                             child: Container(
// //                               margin: const EdgeInsets.only(top: 16),
// //                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                               width: MediaQuery.of(context).size.width,
// //                               decoration: BoxDecoration(
// //                                   color: Colors.black,
// //                                   borderRadius: BorderRadius.circular(8)
// //                               ),
// //                               child:Row(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 crossAxisAlignment: CrossAxisAlignment.center,
// //                                 children: [
// //                                   Text(
// //                                     "Rs. 399/ Month",
// //                                     textAlign: TextAlign.center,
// //                                     style: GoogleFonts.openSans(
// //                                         fontSize: 16,
// //                                         color: Colors.white,
// //                                         fontWeight: FontWeight.bold
// //                                     ),
// //                                   ),
// //                                   // const SizedBox(width: 4),
// //                                   // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
// //                                 ],
// //                               ),
// //                               // color: Colors.black,
// //                               // padding:EdgeInsets.all(10),
// //                               // child: const Text("Rs. 499/month",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16),),
// //                             ),
// //                           ),
// //                           SizedBox(height: 5,),
// //                           const Text("Silver Membership",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
// //                           Divider(color: Colors.black,),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Maximum Books:- 15",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Issue Period:- 25",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Validity:- 30 Days",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height:20,),
// //                           Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               InkWell(
// //                                 onTap: ()=>Navigator.pushReplacementNamed(context, '/home'),
// //                                 child: Container(
// //                                   margin: const EdgeInsets.only(top: 16),
// //                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                                   width: MediaQuery.of(context).size.width,
// //                                   decoration: BoxDecoration(
// //                                       color: Colors.black,
// //                                       borderRadius: BorderRadius.circular(8)
// //                                   ),
// //                                   child: Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     crossAxisAlignment: CrossAxisAlignment.center,
// //                                     children: [
// //                                       Text(
// //                                         "Pay Now",
// //                                         textAlign: TextAlign.center,
// //                                         style: GoogleFonts.openSans(
// //                                             fontSize: 16,
// //                                             color: Colors.white,
// //                                             fontWeight: FontWeight.bold
// //                                         ),
// //                                       ),
// //                                       // const SizedBox(width: 4),
// //                                       // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
// //                                     ],
// //                                   ),
// //                                 ),
// //                               )
// //                             ],
// //                           ),
// //
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Card(
// //                   color: Color.fromRGBO(184,120,51, 1), // Setting the background color to golden
// //                   elevation: 8, // Adding a slight shadow
// //                   margin: EdgeInsets.all(16), // Adding margin for spacing
// //                   child: Padding(
// //                     padding: EdgeInsets.all(16), // Adding padding within the card
// //                     child: Container(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           SizedBox(
// //                             height: 60,
// //                             width: 160,
// //                             child: Container(
// //                               margin: const EdgeInsets.only(top: 16),
// //                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                               width: MediaQuery.of(context).size.width,
// //                               decoration: BoxDecoration(
// //                                   color: Colors.black,
// //                                   borderRadius: BorderRadius.circular(8)
// //                               ),
// //                               child:Row(
// //                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                 crossAxisAlignment: CrossAxisAlignment.center,
// //                                 children: [
// //                                   Text(
// //                                     "Rs. 199/ Month",
// //                                     textAlign: TextAlign.center,
// //                                     style: GoogleFonts.openSans(
// //                                         fontSize: 16,
// //                                         color: Colors.white,
// //                                         fontWeight: FontWeight.bold
// //                                     ),
// //                                   ),
// //                                   // const SizedBox(width: 4),
// //                                   // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
// //                                 ],
// //                               ),
// //                               // color: Colors.black,
// //                               // padding:EdgeInsets.all(10),
// //                               // child: const Text("Rs. 499/month",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 16),),
// //                             ),
// //                           ),
// //                           SizedBox(height: 5,),
// //                           const Text("Bronze Membership",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),
// //                           Divider(color: Colors.black,),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Maximum Books:- 10",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Issue Period:- 15",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height: 10,),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.arrow_forward_outlined,color: Colors.black,),
// //                               Text("Validity:- 30 Days",style: TextStyle(color: Colors.black,fontSize: 17),)
// //                             ],
// //                           ),
// //                           SizedBox(height:20,),
// //                           Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               InkWell(
// //                                 onTap: ()=>Navigator.pushReplacementNamed(context, '/home'),
// //                                 child: Container(
// //                                   margin: const EdgeInsets.only(top: 16),
// //                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                                   width: MediaQuery.of(context).size.width,
// //                                   decoration: BoxDecoration(
// //                                       color: Colors.black,
// //                                       borderRadius: BorderRadius.circular(8)
// //                                   ),
// //                                   child: Row(
// //                                     mainAxisAlignment: MainAxisAlignment.center,
// //                                     crossAxisAlignment: CrossAxisAlignment.center,
// //                                     children: [
// //                                       Text(
// //                                         "Pay Now",
// //                                         textAlign: TextAlign.center,
// //                                         style: GoogleFonts.openSans(
// //                                             fontSize: 16,
// //                                             color: Colors.white,
// //                                             fontWeight: FontWeight.bold
// //                                         ),
// //                                       ),
// //                                       // const SizedBox(width: 4),
// //                                       // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
// //                                     ],
// //                                   ),
// //                                 ),
// //                               )
// //                             ],
// //                           ),
// //
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       )
// //     );
// //   }
// // }
class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  FirebaseFirestore? firestore;
  UserModel? userModel;
  fetch(){
    var uid=FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot> stream= FirebaseFirestore.instance.collection("Subscriptions").snapshots();
    return stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Be a proud member....",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:Color.fromRGBO(0, 0, 128, 1)),
        ),
      ),
      body: StreamBuilder(
        stream: fetch(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              padding: EdgeInsets.all(16),
              children: snapshot.data.docs.map<Widget>((DocumentSnapshot document){
                Map<String,dynamic> map=document.data()! as Map<String,dynamic>;
                return Column(children:[Card(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromRGBO(178, 164, 255, 1),
                            Color.fromRGBO(255, 180, 180, 1),
                            Color.fromRGBO(255, 222, 180, 1),
                            Color.fromRGBO(253, 247, 195, 1),
                          ],
                        )
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Text(map['name'].toString()+" Membership",style: GoogleFonts.robotoSlab(textStyle:TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),),
                        Divider(color: Colors.black,),
                        SizedBox(height: 10,),
                        Text(map['descriptionTitle'].toString(),style: TextStyle(fontSize: 18),),
                        SizedBox(height: 10,),
                        Row(
                            children: [
                              Icon(Icons.circle,color: Colors.black),
                              Text("Maximum Books:- "+map['maxBooks'].toString(),style: GoogleFonts.robotoSlab(textStyle:TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_outlined,color: Colors.black,),
                              Text("Issue Period:- "+map['issuePeriod'].toString(),style: TextStyle(color: Colors.black,fontSize: 17),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_outlined,color: Colors.black,),
                              Text("Price:- Rs. "+map['price'].toString(),style: TextStyle(color: Colors.black,fontSize: 17),)
                            ],
                          ),
                        SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_outlined,color: Colors.black,),
                              Text("Validity:- 30 Days",style: TextStyle(color: Colors.black,fontSize: 17),)
                            ],
                          ),
                          SizedBox(height:20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: ()=>Navigator.pushReplacementNamed(context, '/home'),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Join Now ",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                  SizedBox(height: 8,)
                ]
                );
              }).toList()
          );
        },
      ),
    );
  }
}
