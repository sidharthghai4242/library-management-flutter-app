import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double widthOfBookBox= screenwidth * 0.42;
    if (widthOfBookBox > 300) {
      widthOfBookBox = 200;
    }
    double heightofbookbox = (kIsWeb ? screenwidth *0.25:MediaQuery.of(context).size.height*0.43);
    double heightofimageinbookbox= (kIsWeb ? heightofbookbox*0.68:heightofbookbox*0.6);
    return const Placeholder();
  }
}
