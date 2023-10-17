import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rlr/models/UserModel.dart';
import 'dart:io';
import 'package:rlr/pages/edit_profile.dart';
import 'package:rlr/provider/DbProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../provider/ThemeProvider.dart';
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
    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser != null) {
      await _googleSignIn.signOut();
      // Sign out from Google
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/phone');// Sign out from Google
    }

    // Sign out from Firebase
    await _firebaseAuth.signOut();
    Navigator.pushReplacementNamed(context, '/phone');
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

        // Update Firestore with the image URL for the current user (You need to have userModel defined)
        // await FirebaseFirestore.instance.collection('users').doc(userModel?.userId).update({
        //   'profileImage': imageUrl,
        // });

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
    Color containerColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.white;
    Color MainColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.pink
        : Colors.black;
    Color TextColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return loggingOut? Center(child:  CircularProgressIndicator(),) :  Scaffold(

      appBar: AppBar(
        backgroundColor: containerColor,
        elevation: 0.0,
        title:Text(
          "My Profile",
          style: TextStyle(
            color:  MainColor,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              final isDark = themeProvider.themeData.brightness == Brightness.dark;
              return IconButton(
                onPressed: () {
                  themeProvider.toggleTheme(); // Toggle the theme
                },
                icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
                color: isDark ? Color(0xFFFFDBD1) : Color(0xFF9B442B),
              );
            },
          )
        ],
      ),
      body:SingleChildScrollView(
        child: Container(
          // color: containerColor,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
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
                              CupertinoIcons.pencil,
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
              const SizedBox(height: 10),
              Text(
                userModel?.name ?? 'Guest User',
                style: TextStyle(
                  //  color: TextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userModel?.email ?? '',
                style: TextStyle(
                  //  color: TextColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          userModel: userModel,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFDBD1),
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child:  Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: MainColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFFFFDBD1).withOpacity(0.1),
                  ),
                  child: Icon(
                    CupertinoIcons.heart,
                    color: MainColor,
                  ),
                ),
                title: Text(
                  "My Wishlist",
                  style: TextStyle(
                    //  color: TextColor,
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MainColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: MainColor,
                    )),
              ),
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
                    color: MainColor,
                  ),
                ),
                title:  Text(
                  "Manage Membership",
                  style: TextStyle(
                     // color: TextColor,
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MainColor.withOpacity(0.1),
                    ),
                    child:  Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: MainColor,
                    )),
              ),
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
                    color: MainColor,
                  ),
                ),
                title:  Text(
                  "Help Desk",
                  style: TextStyle(
                     // color: TextColor,
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MainColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: MainColor,
                    )),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFFFFDBD1).withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: MainColor,
                  ),
                ),
                title:  Text(
                  "About Us",
                  style: TextStyle(
                     // color: TextColor,
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MainColor.withOpacity(0.1),
                    ),
                    child:Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: MainColor,
                    )),
              ),

              // Other list items...
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
                    color: MainColor.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.arrow_right,
                    size: 18.0,
                    color: Colors.red,
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
