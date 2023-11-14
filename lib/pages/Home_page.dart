import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rlr/pages/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double menuOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: const Text(
            'Read Ludhiana Read',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Color.fromRGBO(0, 0, 128, 1)// Use a custom font for the app bar title
            ),
          ),
          elevation: 0, // Remove elevation for a modern look
          backgroundColor: Colors.transparent, // Set app bar background color
          iconTheme: IconThemeData(color: Colors.blue), // Set icon color
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/search');
              },
              icon: Icon(Icons.search), // Add an icon to the app bar
            ),
          ],
        ),
        body: Center(
          child: Text(
            'Welcome to RLR App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 0, 128, 1),
            ),
          ),
        ),
        bottomNavigationBar: Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:15.0, vertical: 20),
              child: GNav(
                  backgroundColor: Colors.blue,
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabBackgroundColor: Color.fromRGBO(0, 0, 128, 1),
                  gap: 8,
                  padding: EdgeInsets.all(10),

                  tabs: const [
                    GButton(icon: Icons.home, text: 'Home'),
                    GButton(icon: Icons.book, text: 'My Books'),
                    GButton(icon: Icons.settings, text: 'Settings'),
                    GButton(icon: Icons.person, text: 'My Profile'),

                  ]
              ),
            )
        )
    );
  }
}