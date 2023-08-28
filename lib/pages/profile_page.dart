import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:rlr/provider/DbProvider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    userModel = context.read<DbProvider>().userModel;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0.0,
          title: const Text(
            "My Profile",
            style: TextStyle(
              color: Color(0xFF3B0900),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
                color: isDark ? Color(0xFFFFDBD1) : Color(0xFF9B442B))
          ]),
      body: SingleChildScrollView(
        child: Container(
          color:Color(0xFFFFFFFF) ,
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
                          color: Color(0xFFBA1A1A)),
                      child: const Icon(
                        CupertinoIcons.pencil,
                        color: Color(0xFFFFDBD1),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                userModel!.name ?? 'Guest User',
                style: TextStyle(
                  color: Color(0xFF3B0900),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userModel!.email ?? '',
                style: TextStyle(
                  color: Color(0xFF3B0900),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit_profile');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFDBD1),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Color(0xFF3B0900),
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
                  child: const Icon(
                    CupertinoIcons.cart,
                    color: Color(0xFF3B0900),
                  ),
                ),
                title: const Text(
                  "My Orders",
                  style: TextStyle(
                    color: Color(0xFF3B0900),
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFF3B0900).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: Color(0xFF3B0900),
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
                  child: const Icon(
                    CupertinoIcons.heart,
                    color: Color(0xFF3B0900),
                  ),
                ),
                title: const Text(
                  "My Wishlist",
                  style: TextStyle(
                    color: Color(0xFF3B0900),
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFF3B0900).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: Color(0xFF3B0900),
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
                  child: const Icon(
                    Icons.credit_card,
                    color: Color(0xFF3B0900),
                  ),
                ),
                title: const Text(
                  "Manage Membership",
                  style: TextStyle(
                    color: Color(0xFF3B0900),
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFF3B0900).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: Color(0xFF3B0900),
                    )),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFFFFDBD1).withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF3B0900),
                  ),
                ),
                title: const Text(
                  "Settings",
                  style: TextStyle(
                    color: Color(0xFF3B0900),
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFF3B0900).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: Color(0xFF3B0900),
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
                  child: const Icon(
                    Icons.headset_mic_outlined,
                    color: Color(0xFF3B0900),
                  ),
                ),
                title: const Text(
                  "Help Desk",
                  style: TextStyle(
                    color: Color(0xFF3B0900),
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFF3B0900).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: Color(0xFF3B0900),
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
                  child: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF3B0900),
                  ),
                ),
                title: const Text(
                  "About Us",
                  style: TextStyle(
                    color: Color(0xFF3B0900),
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFF3B0900).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 18.0,
                      color: Color(0xFF3B0900),
                    )),
              ),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/phone');
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFFFFDBD1).withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                ),
                title: const Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                  ),
                ),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFF3B0900).withOpacity(0.1),
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
    );
  }
}