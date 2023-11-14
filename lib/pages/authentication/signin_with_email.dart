import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rlr/provider/DbProvider.dart';
import 'package:rlr/provider/google_signin_provider.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({Key? key}) : super(key: key);

  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool gsign=false;
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
                  'Sign in with Email:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white), // Set the label text color here
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white), // Set the label text color here
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Call the _handleEmailSignIn method with the context
                    _handleEmailSignIn(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set button background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Set text color
                  ),
                  child: Text('Log-In with Email',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the sign-up screen
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set button background color
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Set text color
                  ),
                  child: Text('Sign-up',style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 30),
                Text(
                  'Or Sign in with:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
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
                SizedBox(height: 10), // Add some spacing between the buttons
                SignInButton(
                  Buttons.Facebook,
                  onPressed: () {
                    // Call the _handleFacebookSignIn method with the context
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
