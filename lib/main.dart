import 'package:rlr/pages/authentication/phone_screen.dart';
import 'firebase_options.dart';
import 'package:rlr/pages/splash_screen.dart';
import 'package:rlr/provider/DbProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rlr/pages/Home_page.dart';
import 'package:rlr/helper/color_schemes.g.dart';

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
  User? firebaseUser;
  Widget initialScreen = const SplashScreen();
  BuildContext? bContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), checkAuthState);
  }

  checkAuthState() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        initialScreen = PhoneScreen();
      } else {
        await context.read<DbProvider>().getUserFromFirestore(user: user, bContent: bContext);
        initialScreen = const HomePage();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return initialScreen;
  }
}