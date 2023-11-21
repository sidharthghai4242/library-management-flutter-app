import 'package:rlr/helper/Constants.dart';
import 'package:rlr/helper/UIConstants.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:rlr/provider/DbProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CommonClass {
  static void showSnackBar(BuildContext context, String? title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title ?? ''),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
        ),
        duration: const Duration(seconds: 2),
      )
    );
  }

  static Widget getNavigatorRowItem({ String rowTitle = "", bool isLastItem = false, IconData icon = Icons.chevron_right }) {
    return Container(
      padding: const  EdgeInsets.symmetric(vertical: UIConstants.padding8, horizontal: UIConstants.padding12),
      decoration: BoxDecoration(
          border: !isLastItem ? Border(bottom: BorderSide(color: Colors.grey.shade300)) : null
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            rowTitle,
            style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500
            ),
          ),
          Icon(
            icon,
            color: icon == Icons.chevron_right ? Colors.grey.shade400 : Colors.grey.shade800,
          )
        ],
      ),
    );
  }
  
  void showLoadingErrorModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.1,
        padding: const EdgeInsets.all(UIConstants.padding16),
        decoration: const BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(UIConstants.borderRadius16),
              topLeft: Radius.circular(UIConstants.borderRadius16)
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(strokeWidth: 2.25,)
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Processing your request. Please wait...",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<dynamic> openModalBottomSheet(BuildContext context, {
    Widget? child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = false
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      builder: (context) => child ?? Container(),
    );
  }

  static void openErrorDialog({
    BuildContext? context,
    String message = "",
    bool isPermissionError = false
  }) {
    showDialog(
      context: context!,
      useSafeArea: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius16),
        ),
        child: Container(
          height: isPermissionError ? 350 : 320,
          padding: const EdgeInsets.all(UIConstants.padding8),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 32,
                    width: 32,
                    // padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        // color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.all(Radius.circular(12))
                    ),
                    child: const Icon(Icons.close, size: 18,),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Image.asset(
                "assets/image1.png",
                height: 150,
              ),
              const SizedBox(height: 18),
              Text(
                isPermissionError ? "Insufficient Permissions" : "Error!!",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                    fontSize: isPermissionError ? 20 : 28,
                    fontWeight: FontWeight.w700
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.openSans(
                    fontSize: 16
                ),
              ),
              isPermissionError ? const SizedBox(height: 18) : const SizedBox(),
              isPermissionError ? ElevatedButton(
                onPressed: () {
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UIConstants.borderRadius12)
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.red.shade400)
                ),
                child: Text(
                  "Open Settings",
                  style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600
                  ),
                ),
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }
  
  static Widget emptyScreen(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/healthyPlant.jpeg",
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Put your first image",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
              fontSize: 24
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              "Select either from gallery or click from camera through given options",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey
              ),
            ),
          )
        ],
      ),
    );
  }

  static bool isValidEmail(String email) {
    // Regular expression for basic email validation
    final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }
  static bool isValidPhoneNumber(String phoneNumber) {
    // Regular expression for basic phone number validation
    final RegExp phoneRegExp = RegExp(r'^[0-9]{10}$'); // Assumes 10-digit format
    return phoneRegExp.hasMatch(phoneNumber);
  }


  static Future<dynamic> askedUserInfoViaModalBottomSheet(BuildContext context, {
    User? firebaseUser,
    UserModel? user,
    bool isEditable = true,
    bool isRegistrationProcess = true,
    String? username,
    String? email,
    String? password,
  }) {

    debugPrint(">>> Firebase User: ${firebaseUser.toString()}");
    TextEditingController name = TextEditingController(text: user?.name ?? username ?? ""); // Use the provided username
    TextEditingController phone = TextEditingController(text: user?.phone ?? "");
    TextEditingController emailController = TextEditingController(text: firebaseUser?.email ?? email ?? ""); // Use the provided email
    TextEditingController age = TextEditingController(text: user?.age.toString() ?? "");
    TextEditingController address = TextEditingController(text: user?.address ?? "");

    StatefulBuilder content = StatefulBuilder(
      builder: (context, setState) {
        Color containerColor = MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.black
            : Colors.black;
        // Color Colors.white = MediaQuery.of(context).platformBrightness == Brightness.dark
        //     ? Colors.pink
        //     : Colors.black;
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(12.0),
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24)
              ),
            color: containerColor,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: isRegistrationProcess ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: isRegistrationProcess ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: isRegistrationProcess ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: isRegistrationProcess ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Read Ludhiana Read",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      Text(
                        "Please complete your profile",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),
                      )
                    ],
                  ),
                  !isRegistrationProcess ? OutlinedButton.icon(
                      onPressed: () {
                        isEditable = !isEditable;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: Theme.of(context).colorScheme.primary
                          ))
                      ),
                      label: Text(
                        isEditable ? 'Cancel' : 'Edit',
                        style: GoogleFonts.openSans(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      icon: Icon(isEditable ? Icons.cancel : Icons.edit, color: Theme.of(context).colorScheme.primary)
                  ) : const SizedBox()
                ],
              ),
              const SizedBox(height: 24,),
              Text(
                "${isEditable ? 'Enter your' : ''} Username:",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                child: TextFormField(
                  controller: name,
                  readOnly: !isEditable,
                  keyboardType: TextInputType.name,

                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    // border: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                    //     borderRadius: BorderRadius.circular(8)
                    // ),
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(100),// Set the border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    hintStyle: GoogleFonts.roboto(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              Text(
                "${isEditable ? 'Enter your' : ''} age:",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                child: TextFormField(
                  controller: age,
                  readOnly: !isEditable,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(100),// Set the border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    hintStyle: GoogleFonts.roboto(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              Text(
                "${isEditable ? 'Enter your' : ''} phone:",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                child: TextFormField(
                  controller: phone,
                  readOnly: !isEditable,
                  keyboardType: TextInputType.name,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    // border: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                    //     borderRadius: BorderRadius.circular(8)
                    // ),
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(100),// Set the border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    hintStyle: GoogleFonts.roboto(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              // User EMail
              Text(
                "${isEditable ? 'Enter your' : ''} email:",
                style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
              ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 16),
              child: TextFormField(
                controller: emailController,
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                    color: Colors.white
                ),
                decoration: InputDecoration(
                  counterText: "",
                  // border: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                  //   borderRadius: BorderRadius.circular(8),
                  // ),
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(100),// Set the border color here
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.white), // Set the border color here
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  hintStyle: GoogleFonts.roboto(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey, // You can customize the lock icon color here
                  ),
                ),
              ),
            ),
              // User age

              Text(
                "${isEditable ? 'Enter your' : ''} address:",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                child: TextFormField(
                  controller: address,
                  readOnly: !isEditable,
                  keyboardType: TextInputType.text,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                      color: Colors.white
                  ),
                  maxLines: 3,
                  decoration: InputDecoration(
                    counterText: "",
                    // border: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
                    //     borderRadius: BorderRadius.circular(8)
                    // ),
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(100),// Set the border color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.white), // Set the border color here
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    hintStyle: GoogleFonts.roboto(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if(name.text.isEmpty) {
                    CommonClass.openErrorDialog(context: context, message: "Name is Required");
                    return;
                  }
                  if(emailController.text.isEmpty) {
                    CommonClass.openErrorDialog(context: context, message: "Email is Required");
                    return;
                  }
                  if(emailController.text.isNotEmpty && !CommonClass.isValidEmail(emailController.text)) {
                    CommonClass.openErrorDialog(context: context, message: "Email badly formatted");
                    return;
                  }
                  if(phone.text.isEmpty) {
                    CommonClass.openErrorDialog(context: context, message: "Email is Required");
                    return;
                  }
                  if (phone.text.isNotEmpty &&!CommonClass.isValidPhoneNumber(phone.text)) {
                    CommonClass.openErrorDialog(context: context, message: "Invalid phone number format");
                    return;
                  }

                  if(age.text.isEmpty || age.text == 0 ) {
                    CommonClass.openErrorDialog(context: context, message: "Please enter a valid Age");
                    return;
                  }
                  if(address.text.isEmpty) {
                    CommonClass.openErrorDialog(context: context, message: "Address is Required");
                    return;
                  }
                  if(!isEditable) {
                    Navigator.pop(context, user);
                  } else {
                    UserModel? userModel;
                    debugPrint('isRegistrationProcess: $isRegistrationProcess');
                    debugPrint('firebaseUser: $firebaseUser');

                    if(isRegistrationProcess) {
                      UserModel newUser = UserModel();
                      newUser.token = "";
                      newUser.phone = phone.text.toString();
                      newUser.name =  name.text.toString();
                      newUser.email = emailController.text.toString();
                      newUser.age = int.parse(age.text.toString());
                      newUser.address = address.text.toString();
                      newUser.authId = firebaseUser!.uid;
                      newUser.authId = FirebaseFirestore.instance.collection(Constants.userCollection).doc().id;
                      userModel = newUser;
                      await context.read<DbProvider>().saveUserInFirestore(context: context, userModel: newUser);
                      Navigator.pop(context, userModel);
                    } else {
                      userModel = user;
                      userModel!.name =  name.text.toString();
                      userModel.email = emailController.text.toString();
                      userModel.age = int.parse(age.text.toString());
                      userModel.address = address.text.toString();
                      userModel.authId = user!.authId;
                      await context.read<DbProvider>().saveUserInFirestore(context: context, userModel: userModel);
                      CommonClass.showSnackBar(context, "Profile Updated Successfully");
                      Navigator.pop(context, userModel);
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isEditable ? 'Continue' : 'Close',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.black,

                            fontWeight: FontWeight.bold
                        ),
                      ),
                      // const SizedBox(width: 4),
                      // const Icon(Icons.keyboard_double_arrow_right, color: Colors.white,)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
    return CommonClass.openModalBottomSheet(context, child: content, enableDrag: false, isDismissible: false, isScrollControlled: true, useSafeArea: true);
  }
}