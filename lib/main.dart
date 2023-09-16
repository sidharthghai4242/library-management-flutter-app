import 'package:rlr/pages/activity_page.dart';
import 'package:rlr/pages/all_books.dart';
import 'package:rlr/pages/authentication/phone_screen.dart';
import 'package:rlr/pages/edit_profile.dart';
import 'package:rlr/pages/home_screen.dart';
import 'package:rlr/pages/mybooks_page.dart';
import 'package:rlr/pages/notifications_page.dart';
import 'package:rlr/pages/profile_page.dart';
import 'package:rlr/pages/settings_page.dart';
import 'package:rlr/pages/splash_screen.dart';
import 'package:rlr/provider/DbProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rlr/pages/nav_page.dart';
import 'package:rlr/pages/membership.dart';
import 'package:rlr/helper/color_schemes.g.dart';
import 'package:rlr/pages/search_page.dart';

import 'pages/authentication/signin_with_email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DbProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        routes: {
          '/phone':(context)=>PhoneScreen(),
          '/membership':(context)=>Membership(),
          '/google':(context)=>const GoogleSignInPage(),
          '/search': (context) => const SearchPage(),
          '/home': (context) => const HomeScreen(),
          '/nav' : (context) => NavPage(),
          '/splash': (context) => const SplashScreen(),
          '/profile': (context) => const ProfilePage(),
          '/settings': (context) => const SettingsPage(),
          '/mybooks': (context) => const MyBooksPage(),
          '/activity': (context) => const ActivityPage(),
          '/notifications': (context) => const NotificationsPage(),
          '/edit_profile' : (context) => EditProfilePage(),
          '/allbooks' : (context) => const Allbooks(),

        },

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // User? firebaseUser;
  // Widget initialScreen = const SplashScreen();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), checkAuthState);
  }

  checkAuthState() async {
    debugPrint("checkAuthState");
    User? user = FirebaseAuth.instance.currentUser;
    if(user == null){
      //not login
      Navigator.pushReplacementNamed(context, '/phone');
    }else{
      //logged in
          await context.read<DbProvider>().getUserFromFirestore(user: user, bContent: context);
          debugPrint("after getting user data");
          Navigator.pushReplacementNamed(context, '/nav');
    }
    // FirebaseAuth.instance.authStateChanges().listen((user) async {
    //   if (user == null) {
    //     //
    //     Navigator.pushReplacementNamed(context, '/phone');
    //   } else {
    //     await context.read<DbProvider>().getUserFromFirestore(user: user, bContent: bContext);
    //     initialScreen = const NavPage();
    //   }
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

