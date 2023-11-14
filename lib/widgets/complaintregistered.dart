import 'package:flutter/material.dart';
import 'dart:async';

import '../pages/help_desk_page.dart';



class ComplaintRegistered extends StatefulWidget {
  const ComplaintRegistered({super.key});

  @override
  State<ComplaintRegistered> createState() => _ComplaintRegisteredState();
}

class _ComplaintRegisteredState extends State<ComplaintRegistered> with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    // Delay for 2.5 seconds and then navigate to main.dart
    Future.delayed(Duration(seconds: 6, milliseconds: 700), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HelpDesk(), // Replace 'YourMainWidget' with your main widget
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 130,),
            Container(
              child: Image.asset(
                'assets/Check.gif', // Change 'assets/check.gif' to the correct path
              ),
            ),
            Text(
              "Your inquiry has been\nregistered",
              textAlign: TextAlign.center,
              // Center the text within the column
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50,),
            Text(
                "Our support team will reach out to you soon.",
                style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
