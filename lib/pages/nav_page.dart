import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rlr/pages/activity_page.dart';
import 'package:rlr/pages/my_books.dart';
import 'package:rlr/pages/profile_page.dart';
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
    MyBooks(),
    ActivityPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color containerColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.black
        : Colors.pink;
    Color TextColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Colors.pinkAccent
        : Colors.black;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent
          ),
          child: Container(
            decoration: BoxDecoration(
              color:TextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: GNav(
                  backgroundColor: TextColor,
                  color: containerColor,
                  activeColor: TextColor,
                  tabBackgroundColor: containerColor,
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
      ),
    );
  }
}