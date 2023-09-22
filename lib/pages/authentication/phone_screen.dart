import 'package:firebase_auth/firebase_auth.dart';
import 'package:rlr/helper/CommonClass.dart';
import 'package:rlr/helper/Constants.dart';
import 'package:rlr/helper/UIConstants.dart';
import 'package:rlr/pages/authentication/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class PhoneScreen extends StatelessWidget {
  PhoneScreen({Key? key}) : super(key: key);
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white12,
        centerTitle: true,
        title: Text(
          "",
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoSerif(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: LayoutBuilder(
        builder: (lyContext, constraint) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.minHeight),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/login1.jpg",
                      height: 180,
                      fit: BoxFit.cover,
                    )
                  ),
                  const SizedBox(height: 16,),
                  Text(
                    "Enter Phone Number",
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    "We will send a One Time Password to your phone number",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      // color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 64),
                    child: TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.roboto(),
                      maxLength: 10,
                      onChanged: (value) {
                        // phoneNumberController.text(value);
                      },
                      decoration: InputDecoration(
                        hintText: "+91 99999 ****",
                        counterText: "",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              // color: Colors.blue,
                              width: 1),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        focusColor: UIConstants.colorPrimary.withOpacity(0.8),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                // color: UIConstants.colorPrimary.withOpacity(0.8),
                                width: 1),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        hintStyle: GoogleFonts.roboto(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      if(phoneNumberController.text.length == 10) {

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phoneNumberController.text),)
                        );
                      } else {
                        CommonClass.showSnackBar(context, "Invalid phone number!! Please enter valid number");
                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        //   content: Text("Invalid phone number!! Please enter valid number"),
                        //   behavior: SnackBarBehavior.floating,
                        //   duration: Duration(seconds: 2),
                        //   // backgroundColor: Colors.grey,
                        // ));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Request OTP",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          // const SizedBox(width: 4),
                          // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      Navigator.pushReplacementNamed(context, '/google');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Sign-In with Other Options",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          // const SizedBox(width: 4),
                          // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}