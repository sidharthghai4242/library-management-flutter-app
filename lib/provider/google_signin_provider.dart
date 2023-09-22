//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:rlr/models/UserModel.dart';
// import 'package:rlr/provider/DbProvider.dart';
//
// class GoogleSignInProvider extends ChangeNotifier {
//   final googleSignIn = GoogleSignIn();
//
//   GoogleSignInAccount? _user;
//
//   GoogleSignInAccount get user => _user!;
//
//   Future googleLogin() async {
//     try {
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return;
//       _user = googleUser;
//
//       final googleAuth = await googleUser.authentication;
//
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       await FirebaseAuth.instance.signInWithCredential(credential);
//     } catch (e) {
//       print(e.toString());
//     }
//
//     notifyListeners();
//   }
//
//   Future logout() async {
//     await googleSignIn.disconnect();
//     await FirebaseAuth.instance.signOut();
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:rlr/helper/CommonClass.dart';

import 'DbProvider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<User?> signInWithGoogle(BuildContext context) async {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      debugPrint('googleUser: ${googleUser}');
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
  }
}

