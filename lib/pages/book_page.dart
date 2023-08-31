import 'package:flutter/material.dart';
class BookPage extends StatefulWidget {
  final String?author;
  final String?title;
  final String?url;

  const BookPage({required this.author,required this.title,required this.url});


  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '${widget.author}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:Color.fromRGBO(0, 0, 128, 1)),
        ),
      ),
    );
  }
}
