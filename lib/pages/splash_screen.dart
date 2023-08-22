import 'package:rlr/helper/UIConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/otp1.png", height: 180,),
            Text(
              "Read Ludhiana Read",
              style: GoogleFonts.openSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: UIConstants.colorPrimary
              ),
            ),
            Text(
              "Nothing is pleasanter than exploring a library.",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}
