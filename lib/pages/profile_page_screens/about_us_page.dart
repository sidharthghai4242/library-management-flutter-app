import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double widthOfBookBox= screenwidth;
    if (widthOfBookBox > 300) {
      widthOfBookBox = 500;
    }
    double heightofbookbox = (kIsWeb ? screenwidth *0.25:MediaQuery.of(context).size.height*0.43);
    double heightofimageinbookbox= (kIsWeb ? heightofbookbox*0.67:heightofbookbox*0.6);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "About us",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:Color(0xFF111111),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: screenwidth,
        color: Color(0xFF111111),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Education',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 10),
              Text(
                'A library for children and adults',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Location:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Pakhowal Road (Below Cakes n Coffee) Ldh',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Opening Hours:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,color: Colors.white
                ),
              ),
              Text(
                '12 noon to 6 pm (Mon to Sat)',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Contact:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,color: Colors.white
                ),
              ),
              Text(
                'Ph- 9872899534',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Curated by:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,color: Colors.white
                ),
              ),
              Text(
                '@rumika_3012',
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
