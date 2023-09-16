import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:rlr/provider/DbProvider.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userModel!.name);
    _emailController = TextEditingController(text: widget.userModel!.email);
    _addressController = TextEditingController(text: widget.userModel!.address);
    _phoneController = TextEditingController(text: widget.userModel!.phone);
    _ageController = TextEditingController(text: widget.userModel!.age.toString());
  }

  void _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(widget.userModel!.userId);

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xFF3B0900),
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        'https://w7.pngwing.com/pngs/1008/377/png-transparent-computer-icons-avatar-user-profile-avatar-heroes-black-hair-computer.png',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFFBA1A1A),
                      ),
                      child: const Icon(
                        CupertinoIcons.camera,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
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
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(CupertinoIcons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIconColor: Color(0xFF3B0900),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF9B442B),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
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
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: "Age",
                        prefixIcon: Icon(CupertinoIcons.person_3_fill),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIconColor: Color(0xFF3B0900),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF9B442B),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
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
                    TextFormField(
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
                        prefixIconColor: Color(0xFF3B0900),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF9B442B),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
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
                        prefixIconColor: Color(0xFF3B0900),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF9B442B),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(CupertinoIcons.location_solid),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        prefixIconColor: Color(0xFF3B0900),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF9B442B),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
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
