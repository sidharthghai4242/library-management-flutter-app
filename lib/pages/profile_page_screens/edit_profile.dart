
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:rlr/provider/DbProvider.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:rlr/models/UserModel.dart';
import 'dart:io';
// import 'package:rlr/pages/edit_profile.dart';
// import 'package:rlr/provider/DbProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import '../provider/ThemeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  UserModel? userModel;

  EditProfilePage({
    Key? key,
    this.userModel,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _addressController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;
  UserModel? userModel;
  final picker = ImagePicker();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  File? _pickedImage;
  String? profileImage;





  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userModel!.name);
    _emailController = TextEditingController(text: widget.userModel!.email);
    _addressController = TextEditingController(text: widget.userModel!.address);
    _phoneController = TextEditingController(text: widget.userModel!.phone);
    _ageController = TextEditingController(text: widget.userModel!.age.toString());
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
        // await FirebaseFirestore.instance.collection('users').doc(userModel?.authId).update({
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


  void _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(widget.userModel!.authId);

      if (await userDoc.get().then((doc) => doc.exists)) {
        try {

          widget.userModel!.name = _nameController!.text.toString();
          widget.userModel!.email = _emailController!.text.toString();
          widget.userModel!.address = _addressController!.text.toString();
          widget.userModel!.phone = _phoneController!.text.toString();
          widget.userModel!.age = int.tryParse(_ageController!.text) ?? 0;
          await userDoc.update(widget.userModel!.getMap())
              .then((value) => context.read<DbProvider>().setUserModel(widget.userModel!));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
        } catch (e) {
          print('Error updating profile: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update profile'),
            ),
          );
        }
      } else {
        print('User document not found in Firestore');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height ,
          color: Color(0xFF111111),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 5,),
                  Stack(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(60)
                        ),
                      ),
                      Positioned(
                          top: 7,
                          left: 6,
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios_new,color: Colors.black87,),
                          ))
                    ],
                  ),
                ],
              ),
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(CupertinoIcons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        labelStyle: TextStyle(color: Colors.white), // Set the label text color here
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.white), // Set the border color here
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(100),// Set the border color here
                        ),
                        prefixIconColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _ageController,style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Age",
                        prefixIcon: Icon(CupertinoIcons.person_3_fill),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        labelStyle: TextStyle(color: Colors.white), // Set the label text color here
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.white), // Set the border color here
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(100),// Set the border color here
                        ),
                        prefixIconColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(style: TextStyle(color: Colors.white),
                      controller: _phoneController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        prefixIcon: Icon(CupertinoIcons.phone),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        labelStyle: TextStyle(color: Colors.white), // Set the label text color here
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.white), // Set the border color here
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(100),// Set the border color here
                        ),
                        prefixIconColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(style: TextStyle(color: Colors.white),
                      controller: _emailController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(CupertinoIcons.mail),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        labelStyle: TextStyle(color: Colors.white), // Set the label text color here
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.white), // Set the border color here
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(100),// Set the border color here
                        ),
                        prefixIconColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(style: TextStyle(color: Colors.white),
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(CupertinoIcons.location_solid),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        labelStyle: TextStyle(color: Colors.white), // Set the label text color here
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Colors.white), // Set the border color here
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(100),// Set the border color here
                        ),
                        prefixIconColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateProfile();

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFDBD1),
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Color(0xFF3B0900),
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}