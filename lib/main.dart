import 'package:rlr/pages/activity_page.dart';
import 'package:rlr/pages/all_books.dart';
import 'package:rlr/pages/authentication/phone_screen.dart';
import 'package:rlr/pages/authentication/sign_up_widget.dart';
import 'package:rlr/pages/edit_profile.dart';
import 'package:rlr/pages/help_desk_page.dart';
import 'package:rlr/pages/home_screen.dart';
import 'package:rlr/pages/my_books.dart';
import 'package:rlr/pages/notifications_page.dart';
import 'package:rlr/pages/profile_page.dart';
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
import 'package:rlr/provider/ThemeProvider.dart';
import 'pages/authentication/signin_with_email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            lightColorScheme: lightColorScheme, // Pass the light color scheme
            darkColorScheme: darkColorScheme,
            // Pass the dark color scheme
          ),
        ),
        ChangeNotifierProvider(create: (_) => DbProvider()),
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: context.watch<ThemeProvider>().themeData,
      // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
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
        // '/settings': (context) => const SettingsPage(),
        '/mybooks': (context) => const MyBooks(),
        '/activity': (context) => const ActivityPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/edit_profile' : (context) => EditProfilePage(),
        '/allbooks' : (context) => const Allbooks(),
        '/signup':(context)=>SignUpPage(),
        '/helpdesk':(context)=>HelpDesk(),

      },
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
      Navigator.pushReplacementNamed(context, '/google');
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

