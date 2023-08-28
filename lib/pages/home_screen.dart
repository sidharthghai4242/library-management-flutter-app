import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'Read Ludhiana Read',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 128, 1),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            icon: Icon(CupertinoIcons.bell_fill),
          ),
        ],
      ),
      body: Productlistpage(),
    );
  }
}
// class Productlistpage extends StatefulWidget {
//   const Productlistpage({super.key});
//
//   @override
//   State<Productlistpage> createState() => _ProductlistpageState();
// }
//
// class _ProductlistpageState extends State<Productlistpage> {
//   Color _colorContainer = Colors.blue;
//   String value="";
//   fetch(){
//     var uid=FirebaseAuth.instance.currentUser!.uid;
//     Stream<QuerySnapshot> stream= FirebaseFirestore.instance.collection("Tags").snapshots();
//     return stream;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: fetch(),
//         builder: (BuildContext context,AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return ListView(
//             padding: EdgeInsets.all(16),
//           scrollDirection: Axis.horizontal,
//           children: snapshot.data.docs.map<Widget>((DocumentSnapshot document){
//             Map<String,dynamic> map=document.data()! as Map<String,dynamic>;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 5,),
//                 Row(
//                   children: [
//                     Ink(
//                         child: InkWell(
//                           child: Row(
//                             children: [
//                               Container(
//                                   padding: EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                       color: _colorContainer ,
//                                       borderRadius: BorderRadius.circular(10)
//                                   ),
//                                   child:Text(map['name'].toString())
//                               ),
//                               SizedBox(width: 10,)
//                             ],
//                           ),
//                           onTap: () {
//                             setState(() {
//                               _colorContainer = _colorContainer == Colors.red ?
//                               Colors.blue :
//                               Colors.red;
//                             });
//                           },
//                         )),
//                   ],
//                 )
//               ],
//             );
//           }).toList()
//           );
//         }
//       ),
//     );
//   }
// }
class Productlistpage extends StatefulWidget {
  const Productlistpage({super.key});

  @override
  State<Productlistpage> createState() => _ProductlistpageState();
}

class _ProductlistpageState extends State<Productlistpage> {
  List<Color> _buttonColors = [];
  String value = "";

  fetch() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot> stream =
    FirebaseFirestore.instance.collection("Tags").snapshots();
    return stream;
  }

  @override
  void initState() {
    super.initState();
    _buttonColors = List.generate(10, (index) => Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> docs = snapshot.data.docs;

          return ListView(
            padding: EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            children: docs.asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              QueryDocumentSnapshot document = entry.value;
              Map<String, dynamic> map =
              document.data()! as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Ink(
                        child: InkWell(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _buttonColors[index],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(map['name'].toString()),
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _buttonColors[index] =
                              _buttonColors[index] == Colors.red
                                  ? Colors.blue
                                  : Colors.red;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
