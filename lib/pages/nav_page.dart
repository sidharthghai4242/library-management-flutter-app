import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rlr/pages/activity_page.dart';
import 'package:rlr/pages/profile_page.dart';
import 'package:rlr/pages/mybooks_page.dart';
import 'package:rlr/pages/home_screen.dart';
import 'package:rlr/pages/search_page.dart';
import 'package:flutter/cupertino.dart';


class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _HomePageState();
}

class _HomePageState extends State<NavPage> {
  int _currentIndex = 0; // Index of the selected bottom navigation bar item

  final List<Widget> _screens = [
    HomeScreen(),
    SearchPage(),
    MyBooksPage(),
    ActivityPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              color: Color(0xFFFFDBD1),
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: GNav(
                backgroundColor: Color(0xFFFFDBD1),
                color: Color(0xFF3B0900),
                activeColor: Color(0xFF3B0900),
                tabBackgroundColor: Color(0xFF9B442B),
                gap: 8,
                padding: EdgeInsets.all(10),
                tabs: [
                  GButton(icon: Icons.home,text: 'Home',),
                  GButton(icon: Icons.search, text: 'Search'),
                  GButton(icon: Icons.book, text: 'My Books'),
                  GButton(icon: Icons.auto_graph_sharp,text: 'My Activity',),
                  GButton(icon: Icons.person,text: 'My Profile',),
                ],
                selectedIndex: _currentIndex,
                onTabChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}