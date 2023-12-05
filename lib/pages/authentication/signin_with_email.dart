import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rlr/provider/DbProvider.dart';
import 'package:rlr/provider/google_signin_provider.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({Key? key}) : super(key: key);

  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  late Timer _timer;
  int _currentIndex = 0;
  final List<String> _quotes = [
    "Nothing is pleasanter than exploring a library.",
    "Libraries store the energy that fuels the imagination.",
    "The only thing that you absolutely have to know is the location of the library.",
    "In the library, time is dammed up - not just stopped but saved.",
    "Libraries are the future of reading. It's sad to see so many bookshops close down because they've been my sanctuary growing up.",
    "A library is a hospital for the mind.",
    "Libraries were full of ideas - perhaps the most dangerous and powerful of all weapons.",
    "A great library is a collection of books just as a collection of books is not necessarily a library.",
    "When in doubt, go to the library.",
    "Without libraries, what have we? We have no past and no future.",
    "Libraries will get you through times of no money better than money will get you through times of no libraries.",
    "The library card is a passport to wonders and miracles, glimpses into other lives, religions, experiences, the hopes and dreams and strivings of ALL human beings.",
    "A library is not a luxury but one of the necessities of life.",
    "I have always imagined that Paradise will be a kind of library.",
    "A library is the delivery room for the birth of ideas, a place where history comes to life."
  ];

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool gsign=false;
  @override
  void initState() {
    super.initState();
    _startQuoteTimer();
  }
  void _startQuoteTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _quotes.length;
      });
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  Future<void> _handleEmailSignIn(BuildContext context) async {
    final auth = FirebaseAuth.instance;


    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user!.uid.isNotEmpty){
        await context.read<DbProvider>().getUserFromFirestore(user: userCredential.user, bContent: context);
        Navigator.pushReplacementNamed(context, '/nav');
      }
    } on FirebaseAuthException catch(e){
    print("sth went wrong"+e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return gsign? (Center(child:CircularProgressIndicator())):Scaffold(
      body:Container(
        color: Color(0xFF111111),
        child:  Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 180,
                  child: Image.asset('assets/rlrblack.jpg'),
                ),
                Text(
                  "Read Ludhiana Read",
                  style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                Container(
                  height: 150,
                  child: Text(
                    _quotes[_currentIndex],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Text(
                  'Please sign-in with your "Google" account:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

               //  SizedBox(height: 10),
               //  Container(
               //    width: 400,
               //    child:TextFormField(
               //      controller: emailController,
               //      keyboardType: TextInputType.emailAddress,
               //      decoration: InputDecoration(
               //        labelText: 'Email',
               //        labelStyle: TextStyle(color: Colors.white), // Set the label text color here
               //        focusedBorder: OutlineInputBorder(
               //          borderSide: BorderSide(color: Colors.white),
               //          borderRadius: BorderRadius.circular(100),// Set the border color here
               //        ),
               //        enabledBorder: OutlineInputBorder(
               //          borderRadius: BorderRadius.circular(100),
               //          borderSide: BorderSide(color: Colors.white), // Set the border color here
               //        ),
               //        border: OutlineInputBorder(
               //          borderRadius: BorderRadius.circular(100),
               //        ),
               //      ),
               //    ),
               //  ),
               //  SizedBox(height: 10),
               // Container(
               //   width: 400,
               //   child:  TextFormField(
               //     controller: passwordController,
               //     obscureText: true,
               //     decoration: InputDecoration(
               //       labelText: 'Password',
               //       labelStyle: TextStyle(color: Colors.white), // Set the label text color here
               //       focusedBorder: OutlineInputBorder(
               //         borderSide: BorderSide(color: Colors.white),
               //         borderRadius: BorderRadius.circular(100),// Set the border color here
               //       ),
               //       enabledBorder: OutlineInputBorder(
               //         borderRadius: BorderRadius.circular(100),
               //         borderSide: BorderSide(color: Colors.white), // Set the border color here
               //       ),
               //       border: OutlineInputBorder(
               //         borderRadius: BorderRadius.circular(100),
               //       ),
               //     ),
               //   ),
               // ),
               //  SizedBox(height: 10),
               //  ElevatedButton(
               //    onPressed: () {
               //      // Call the _handleEmailSignIn method with the context
               //      _handleEmailSignIn(context);
               //    },
               //    style: ButtonStyle(
               //      backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set button background color
               //      foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Set text color
               //    ),
               //    child: Text('Log-In with Email',style: TextStyle(fontWeight: FontWeight.bold),),
               //  ),
               //  SizedBox(height: 10),
               //  ElevatedButton(
               //    onPressed: () {
               //      // Navigate to the sign-up screen
               //      Navigator.pushNamed(context, '/signup');
               //    },
               //    style: ButtonStyle(
               //      backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set button background color
               //      foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Set text color
               //    ),
               //    child: Text('Sign-up',style: TextStyle(fontWeight: FontWeight.bold),),
               //  ),
               //  SizedBox(height: 30),
               //  Text(
               //    'Or Sign in with:',
               //    style: TextStyle(
               //      fontSize: 18,
               //      color: Colors.grey,
               //    ),
               //  ),
                SizedBox(height: 10),
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    User? user = await AuthService().signInWithGoogle(context);
                    if(user != null){
                      debugPrint('User: $user');
                      setState(() {
                        gsign=true;
                      });
                      await context.read<DbProvider>().getUserFromFirestore(user: user, bContent: context);
                      Navigator.of(context).pushReplacementNamed('/nav');
                    }else{
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      )
    );
  }
}
