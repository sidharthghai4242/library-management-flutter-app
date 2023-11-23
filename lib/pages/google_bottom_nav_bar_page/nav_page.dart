import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rlr/pages/activity_page_screens/activity_page.dart';
import 'package:rlr/pages/my_books_page_screens/my_books.dart';
import 'package:rlr/pages/profile_page_screens/profile_page.dart';
import 'package:rlr/pages/home_screen_pages/home_screen.dart';
import 'package:rlr/pages/search_page_screen/search_page.dart';
import 'package:flutter/cupertino.dart';


class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _HomePageState();
}

class _HomePageState extends State<NavPage> {
  int _currentIndex = 0; // Index of the selected bottom navigation bar item
  Color primaryColorLight = Color(0xFFFFFFFF); // Soft sky blue// Soft pastel blue
  Color secondaryColorLight = Color(0xFFFF9E33); // Bright orange
  Color tertiaryColorLight = Color(0xFF3E2723);
  Color neutralColorLight=Color(0xFF0A1746);// Dark chocolate brown
  Color primaryColorDark = Color(0xFF000000); // Midnight blue
  Color secondaryColorDark = Color(0xFF000000); // Electric purple// You can also use Colors.purpleAccent.
  Color tertiaryColorDark = Color(0xFFE900FF);
  Color neutralColorDark=Colors.deepPurple;
  final List<Widget> _screens = [
    HomeScreen(),
    SearchPage(),
    ActivityPage(),
    MyBooks(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color primaryColor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? primaryColorDark
        : primaryColorLight;

    Color secondarycolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? secondaryColorDark
        : secondaryColorLight;

    Color tertiarycolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? tertiaryColorDark
        : tertiaryColorLight;
    Color neutralcolor = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? neutralColorDark
        : neutralColorLight;
    Color? grey=Colors.grey[300];
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          child: Container(
            height:76.26,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 5, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: Offset(0, 3), // Offset
                ),
              ],
              color: Colors.white,
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
                  backgroundColor: Colors.transparent,
                  color: Colors.black,
                  activeColor: Colors.white,
                  tabBackgroundColor: Colors.black,
                  gap: 5,
                  padding: EdgeInsets.all(10),
                  tabs: [
                    GButton(icon: Icons.home, text: 'Home'),
                    GButton(icon: Icons.search, text: 'Search'),
                    GButton(icon: Icons.auto_graph_outlined,text:'My Activity'),
                    GButton(icon: Icons.book, text: 'Issued Books'),
                    GButton(icon: Icons.person, text: 'My Profile'),
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