import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:rlr/pages/edit_profile.dart';
import 'package:rlr/provider/DbProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rlr/helper/color_schemes.g.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDark = false; // Initialize with the light theme
  UserModel? userModel;
  bool loggingOut = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
  }// Track whether log out process is in progress

  @override
  Widget build(BuildContext context) {
    userModel = context.watch<DbProvider>().userModel;
    // String name = userModel?.name ?? "name";
    // String email = userModel?.email ?? "email";
    // int age = userModel?.age ?? 18;
    // String phone = userModel?.phone ?? "+910000000000";
    // String address = userModel?.address ?? "address";
    // String userId = userModel?.userId ?? " ";
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
    return loggingOut? Center(child: CircularProgressIndicator(),) :  Scaffold(

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
            IconButton(
              onPressed: () {
                setState(() {
                  isDark = !isDark; // Toggle the theme
                });
              },
              icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
              color: isDark ? Color(0xFFFFDBD1) : Color(0xFF9B442B),
            )
          ],
      ),
      body:SingleChildScrollView(
        child: Container(
          color: containerColor,
          padding: const EdgeInsets.all(10.0),
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
                userModel?.name ?? 'Guest User',
                style: TextStyle(
                  color: TextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                userModel?.email ?? '',
                style: TextStyle(
                  color: TextColor,
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
                  child:  Icon(
                    CupertinoIcons.cart,
                    color: MainColor,
                  ),
                ),
                title:  Text(
                  "My Orders",
                  style: TextStyle(
                    color: TextColor,
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
                    color: TextColor,
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
                    color: TextColor,
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
                  child: Icon(
                    Icons.settings_outlined,
                    color: MainColor,
                  ),
                ),
                title:  Text(
                  "Settings",
                  style: TextStyle(
                    color: TextColor,
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
                    color: TextColor,
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
                    color: TextColor,
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
                    color: loggingOut ? Colors.grey : Colors.red, // Change color based on log out state
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
