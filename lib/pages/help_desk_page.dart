import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:rlr/models/UserModel.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../provider/DbProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelpDesk extends StatelessWidget {
  const HelpDesk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Desk'),
        backgroundColor: Theme.of(context).primaryColor, // Use primaryColor as background color
        iconTheme: IconThemeData(color: Colors.pink), // Icon color
        shadowColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white // Use white shadow color for dark theme
            : Colors.black, // Use black shadow color for light theme
      ),
      body: HelpDeskBody(),
    );
  }
}

class HelpDeskBody extends StatefulWidget {
  @override
  _HelpDeskBodyState createState() => _HelpDeskBodyState();
}

class _HelpDeskBodyState extends State<HelpDeskBody> {
  final TextEditingController messageController = TextEditingController();
  bool isSubmitting = false; // For tracking submission state

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    _scaffoldKey.currentState!.showBottomSheet(
          (context) => ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );

    // Close the modal sheet after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

  Future<void> handleSubmit() async {
    // Simulate an API call or processing time

    // Implement your submit button functionality here
    String message = messageController.text;

    // Check if the message is empty
    if (message.isEmpty) {
      _showMessage('Message is empty. Please enter a message before submitting.');
    } else {
      setState(() {
        isSubmitting = true;
      });

      await Future.delayed(Duration(seconds: 2));
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the user's ID from userModel
      String userId = context.read<DbProvider>().userModel?.userId ?? '';

      // Check if the userId is available
      if (userId.isNotEmpty) {
        // Create or access the 'inquiries' collection within the 'users' collection
        CollectionReference inquiriesCollection =
        firestore.collection('users').doc(userId).collection('inquiries');

        // Create a map to represent the data you want to store in the document
        Map<String, dynamic> inquiryData = {
          'inquirymessage': message,
          'timestamp': FieldValue.serverTimestamp(), // Optional: Timestamp field
        };

        // Add the document to the 'inquiries' collection
        await inquiriesCollection.add(inquiryData);

        // You can process the message or send it to the help desk here.
        _showMessage('Message submitted');
        print('Submitted message: $message');
      } else {
        print('User ID is not available');
      }

      // Clear the message text field
      messageController.clear();

      setState(() {
        isSubmitting = false;
      });
    }

    // Show a success message or navigate to a confirmation screen
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = context.watch<DbProvider>().userModel;
    Brightness brightness = MediaQuery.of(context).platformBrightness;

    // Define gradient colors based on brightness
    List<Color> gradientColors = brightness == Brightness.dark
        ? [Colors.yellowAccent, Colors.amber, Colors.white, Colors.grey]
        : [Colors.blue.shade200, Colors.blue.shade400];

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: brightness == Brightness.dark ? Colors.black : Colors.white, // Toggle body color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientText(
                'Welcome to the Help Desk, ${userModel?.name ?? 'Guest'}!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: brightness == Brightness.dark ? Colors.white : Colors.black,
                ), colors: [
                if(MediaQuery.of(context).platformBrightness == Brightness.dark)...[
                  Color(0xFFFFD700), Colors.amber, Colors.orange
                ]else...[
                  Colors.black,Colors.black87,Colors.black54,
                ]
              ],
              ),
              SizedBox(height: 20),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        colors: [
                          if(MediaQuery.of(context).platformBrightness == Brightness.dark)...[
                            Color(0xFFFFD700), Colors.amber, Colors.orange
                          ]else...[
                            Colors.black,Colors.black87,Colors.black54,
                          ]
                        ]),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: messageController,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 200, // Set the desired width
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : handleSubmit,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      onPrimary: Colors.white,
                      elevation: 5,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isSubmitting
                        ? Text(
                      'Submitting',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
