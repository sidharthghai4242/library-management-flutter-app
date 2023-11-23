import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rlr/models/UserModel.dart';
import 'dart:io';
import 'package:rlr/pages/profile_page_screens/edit_profile.dart';
import 'package:rlr/provider/DbProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../provider/ThemeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;


import 'package:firebase_storage/firebase_storage.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDark = false; // Initialize with the light theme
  UserModel? userModel;
  bool loggingOut = false;
  final picker = ImagePicker();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  File? _pickedImage;
  String? profileImage;
  Future<void> signOut() async {
    // Check if the user is signed in with Google
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser != null) {
      await _googleSignIn.signOut();
      // Sign out from Google
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/google');// Sign out from Google
    }

    // Sign out from Firebase
    await _firebaseAuth.signOut();
    Navigator.pushReplacementNamed(context, '/google');
  }

  @override
  void initState() {
    super.initState();
    // Load the picked image path from SharedPreferences when the app starts
    _loadImageFromSharedPreferences();
  }


  Future<void> _loadImageFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('pickedImage');
    if (imagePath != null) {
      setState(() {
        _pickedImage = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      // Upload the image to Firebase Storage
      String imageName = 'profile_images/${DateTime.now().toString()}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(imageName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot storageTaskSnapshot = await uploadTask;

      if (storageTaskSnapshot.state == TaskState.success) {
        // Image uploaded successfully, now get the URL
        String imageUrl = await ref.getDownloadURL();
        // Save the picked image path to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('pickedImage', imageFile.path);

        setState(() {
          _pickedImage = imageFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userModel = context.watch<DbProvider>().userModel;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return loggingOut? Center(child:  CircularProgressIndicator(),) :  Scaffold(
      body:SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height *1,
           color: Color(0xFF111111),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 40,),
              if(userModel!.subscription.name.isEmpty)...[
               Container(
                 padding: EdgeInsets.all(8),
                 child:  Container(
                   decoration: BoxDecoration(
                       color: Colors.black,
                       border: Border.all(
                           color: Color(0xFFA37E49)
                       ),
                       borderRadius: BorderRadius.circular(10)
                   ),
                   // padding: EdgeInsets.all(10),
                   child: Column(
                     children: [
                       Container(
                         padding: EdgeInsets.all(10),
                         child: Row(
                           children: [
                             Stack(
                               children: [
                                 Stack(
                                   children: [
                                     Container(
                                       width: 80,
                                       height: 80,
                                       child: ClipOval(
                                         child: _pickedImage != null
                                             ? Image.file(
                                           _pickedImage!,
                                           fit: BoxFit.cover, // This property makes the image cover the entire box
                                         )
                                             : Image.network(
                                           'https://w7.pngwing.com/pngs/1008/377/png-transparent-computer-icons-avatar-user-profile-avatar-heroes-black-hair-computer.png',
                                           fit: BoxFit.cover, // Set the fit property for the network image as well
                                         ),
                                       ),
                                     ),
                                     Positioned(
                                       bottom: 0,
                                       right: 0,
                                       child: GestureDetector(
                                         onTap: () async{
                                           _pickImage();
                                         },
                                         child: Container(
                                           width: 35,
                                           height: 35,
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(100),
                                             color: Color(0xFFBA1A1A),
                                           ),
                                           child: Icon(
                                             CupertinoIcons.camera,
                                             color: Color(0xFFFFDBD1),
                                             size: 20,
                                           ),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                             SizedBox(width: 12,),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 SizedBox(height:3,),
                                 GradientText(
                                   userModel?.name ?? 'Guest User',
                                   style: TextStyle(
                                     // color: Colors.white,
                                     fontSize: 22.0,
                                     fontWeight: FontWeight.bold,
                                   ), colors: [
                                   Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFFE1C16E),
                                 ],
                                 ),
                                 SizedBox(height:3,),
                                 Container(
                                   width: 205,
                                   child: Text(
                                     userModel?.email ?? '',
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 15.0,
                                       fontWeight: FontWeight.normal,
                                     ),
                                   ),
                                 ),
                                 SizedBox(height:3,),
                               ],
                             )
                           ],
                         ),
                       ),
                       SizedBox(height: 5,),
                       Divider(color: Color(0xFFA37E49),),
                       InkWell(
                         child:Container(
                           padding: EdgeInsets.only(
                               top: 5,
                               left: 10,
                               right: 10,
                               bottom: 10
                           ),
                           child:  Row(
                             children: [
                               Stack(
                                 children: [
                                   Container(
                                     decoration: BoxDecoration(
                                       color: Color(0xFFA37E49).withOpacity(0.4),
                                       borderRadius: BorderRadius.circular(60),
                                     ),
                                     height: 40,
                                     width: 40,
                                     child: ClipOval(
                                       child: Text(""),
                                     ),
                                   ),
                                   Positioned(
                                     top: 6,  // Adjust the top position as needed
                                     left: 6, // Adjust the left position as needed
                                     child: Container(
                                       decoration: BoxDecoration(
                                         gradient: LinearGradient(
                                             begin: Alignment.centerLeft,
                                             end: Alignment.centerRight,
                                             colors: [
                                               Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFFE1C16E),
                                             ]
                                         ),
                                         borderRadius: BorderRadius.circular(60),
                                       ),
                                       height: 27,
                                       width: 27,
                                       child: ClipOval(
                                         child: Container(
                                           child: Image.asset("assets/blackcrown.png"),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(width: 5,),
                               Text("Become a member",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                               Spacer(),
                               InkWell(
                                 onTap: () {
                                   Navigator.pushNamed(context, '/membership');
                                 },
                                 child:  Container(
                                     width: 90,
                                     height:40,
                                     padding:  EdgeInsets.all(8),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),
                                       gradient: LinearGradient(
                                           colors:  [Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFF966919)]
                                       ),
                                       // border: Border.all(
                                       //     color: Colors.black
                                       // )
                                     ),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Text("Join Now",style:TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 15)),
                                       ],
                                     )
                                 ),
                               )
                             ],
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               )
              ],
              if(userModel!.subscription.name.isNotEmpty)...[
                Container(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            color: Color(0xFFA37E49)
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    // padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        child: ClipOval(
                                          child: _pickedImage != null
                                              ? Image.file(
                                            _pickedImage!,
                                            fit: BoxFit.cover, // This property makes the image cover the entire box
                                          )
                                              : Image.network(
                                            'https://w7.pngwing.com/pngs/1008/377/png-transparent-computer-icons-avatar-user-profile-avatar-heroes-black-hair-computer.png',
                                            fit: BoxFit.cover, // Set the fit property for the network image as well
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () async{
                                            _pickImage();
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Color(0xFFBA1A1A),
                                            ),
                                            child: Icon(
                                              CupertinoIcons.camera,
                                              color: Color(0xFFFFDBD1),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height:3,),
                                  GradientText(
                                    userModel?.name ?? 'Guest User',
                                    style: TextStyle(
                                      // color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ), colors: [
                                    Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFFE1C16E),
                                  ],
                                  ),
                                  SizedBox(height:3,),
                                  Text(
                                    userModel?.email ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height:3,),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Divider(color: Color(0xFFA37E49),),
                        InkWell(
                          child:Container(
                            padding: EdgeInsets.only(
                                top: 5,
                                left: 10,
                                right: 10,
                                bottom: 10
                            ),
                            child:  Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFA37E49).withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: ClipOval(
                                        child: Text(""),
                                      ),
                                    ),
                                    Positioned(
                                      top: 6,  // Adjust the top position as needed
                                      left: 6, // Adjust the left position as needed
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFFE1C16E),
                                              ]
                                          ),
                                          borderRadius: BorderRadius.circular(60),
                                        ),
                                        height: 27,
                                        width: 27,
                                        child: ClipOval(
                                          child: Container(
                                            child: Image.asset("assets/blackcrown.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 5,),
                               Container(
                                 width: 150,
                                 child:  GradientText(userModel!.subscription.name +" Membership",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold), colors: [Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFFE1C16E),],),
                               ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/membership');
                                  },
                                  child:  Container(
                                      width: (kIsWeb ? 105:95),
                                      height:40,
                                      padding:  EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            colors:  [Color(0xFFE1C16E),Color(0xFFfffdd0) ,Color(0xFF966919)]
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Know More",style:TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 15)),
                                        ],
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Card(
                  elevation: 4,
                  color: Colors.black.withOpacity(0.7),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                userModel: userModel,
                              ),
                            ),
                          );
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFFFDBD1).withOpacity(0.1),
                          ),
                          child: Icon(
                            CupertinoIcons.pencil_circle,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.arrow_right,
                              size: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      const Divider(color: Colors.grey,indent: 20,endIndent: 17,),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/wishlist');
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFFFDBD1).withOpacity(0.1),
                          ),
                          child: Icon(
                            CupertinoIcons.heart,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "My Wishlist",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.arrow_right,
                              size: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      const Divider(color: Colors.grey,indent: 20,endIndent: 17,),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/membership');
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFFFDBD1).withOpacity(0.1),
                          ),
                          child:  Icon(
                            Icons.credit_card,
                            color: Colors.white,
                          ),
                        ),
                        title:  Text(
                          "Manage Membership",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black.withOpacity(0.1),
                            ),
                            child:  Icon(
                              Icons.arrow_right,
                              size: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      const Divider(color: Colors.grey,indent: 20,endIndent: 17,),
                      ListTile(
                        onTap: (){
                          Navigator.pushNamed(context, '/helpdesk');
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFFFDBD1).withOpacity(0.1),
                          ),
                          child:  Icon(
                            Icons.headset_mic_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title:  Text(
                          "Help Desk",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.arrow_right,
                              size: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      const Divider(color: Colors.grey,indent: 20,endIndent: 17,),
                      ListTile(
                        onTap: (){
                          Navigator.pushNamed(context, '/aboutus');
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFFFDBD1).withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                        ),
                        title:  Text(
                          "About Us",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black.withOpacity(0.1),
                            ),
                            child:Icon(
                              Icons.arrow_right,
                              size: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      const Divider(color: Colors.grey,indent: 20,endIndent: 17,),
                      ListTile(
                        onTap: () async {

                          if (!loggingOut) {
                            setState(() {
                              loggingOut = true; // Start the log out process
                            });
                            signOut();
                          }
                        },
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFFFDBD1).withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.exit_to_app,
                            color: loggingOut ? Colors.grey : Colors.red, // Change color based on log out state
                          ),
                        ),
                        title: Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.red, // Change color based on log out state
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.arrow_right,
                            size: 18.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Circular Progress Indicator shown when logging out
              if (loggingOut) ...[
                SizedBox(height: 30),
                CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}