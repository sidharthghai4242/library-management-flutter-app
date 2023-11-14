import 'package:rlr/helper/UIConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF111111),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset( MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? 'assets/rlrblack.jpg'
                  : 'assets/rlrblack.jpg', height: 180,),
              Text(
                "Read Ludhiana Read",
                style: GoogleFonts.openSans(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
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
      ),
    );
  }
}
