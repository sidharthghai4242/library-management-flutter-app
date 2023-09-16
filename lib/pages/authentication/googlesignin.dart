// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
//
// class GoogleSignInPage extends StatelessWidget {
//   const GoogleSignInPage({Key? key}) : super(key: key);
//
//   Future<void> _handleGoogleSignIn(BuildContext context) async {
//     // Implement Google Sign-In logic here
//     // You can use packages like 'google_sign_in' or 'firebase_auth' for Google Sign-In integration.
//   }
//
//   Future<void> _handleFacebookSignIn(BuildContext context) async {
//     // Implement Facebook Sign-In logic here
//     // You can use packages like 'flutter_facebook_auth' for Facebook Sign-In integration.
//   }
//
//   Future<void> _handleEmailSignIn(BuildContext context) async {
//     final auth = FirebaseAuth.instance;
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();
//
//     try {
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();
//
//       final userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
//
//       // Check if the user exists (sign-in successful)
//       if (userCredential.user != null) {
//         // If the user exists, navigate to the main app screen (e.g., HomeScreen)
//         Navigator.of(context).pushReplacementNamed('/home');
//       } else {
//         // If the user doesn't exist, create a new user
//         await auth.createUserWithEmailAndPassword(email: email, password: password);
//
//         // Navigate to the GetInfoPage while passing the email and password
//         Navigator.of(context).pushReplacementNamed(
//           '/getinfo',
//           arguments: {'email': email, 'password': password},
//         );
//       }
//     } catch (e) {
//       // Handle sign-in errors here
//       print('Sign-In Error: $e');
//       // Show an error message to the user if needed
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Sign-In Error: $e'),
//       ));
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign-In Example'),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'Welcome to RLR App',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 30),
//               Text(
//                 'Sign in with Email:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.grey,
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   // Call the _handleEmailSignIn method with the context
//                   _handleEmailSignIn(context);
//                 },
//                 child: Text('Log-In with Email'),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   // Navigate to the sign-up screen
//
//                 },
//                 child: Text('Sign-up'),
//               ),
//               SizedBox(height: 30),
//               Text(
//                 'Or Sign in with:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.grey,
//                 ),
//               ),
//               SizedBox(height: 10),
//               SignInButton(
//                 Buttons.Google,
//                 onPressed: () {
//                   // Call the _handleGoogleSignIn method with the context
//                   _handleGoogleSignIn(context);
//                 },
//               ),
//               SizedBox(height: 10), // Add some spacing between the buttons
//               SignInButton(
//                 Buttons.Facebook,
//                 onPressed: () {
//                   // Call the _handleFacebookSignIn method with the context
//                   _handleFacebookSignIn(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
