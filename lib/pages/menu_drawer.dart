import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  fetch() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection(
        "users").snapshots();
    return stream;
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('user'),
            accountEmail: Text('user@example.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://w7.pngwing.com/pngs/1008/377/png-transparent-computer-icons-avatar-user-profile-avatar-heroes-black-hair-computer.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 128, 1),
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.black),
            title: Text('Wishlist'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.library_books, color: Colors.black),

            title: Text('Manage Books'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.credit_card, color: Colors.black),
            title: Text('Edit Membership'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: Text('About Us'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.black),
            title: Text('Exit'),
            onTap: () => null,
          ),
          Divider(),
        ],
      ),
    );
  }
}