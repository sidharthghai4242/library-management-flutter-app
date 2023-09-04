import 'package:flutter/material.dart';

class BookModel {
  String? book_title;
  String? author_name;
  String? genre;

  BookModel(this.book_title, this.author_name, this.genre); // Add a semicolon here
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key})
      : super(key: key); // Use 'key' instead of 'super.key'

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static List<BookModel> main_books_list = [
    BookModel("A Tale Of Two Cities", "Charles Dickens", "Historical fiction"),
    BookModel(
        "Harry Potter and the Philosopher's Stone", "J. K. Rowling", "Fantasy"),
    BookModel("Vardi Wala Gunda", "Ved Prakash Sharma", "Detective"),
    BookModel("Who Moved My Cheese?", "Spencer Johnson", "Self-help"),
    BookModel("A Brief History of Time", "Stephen Hawking", "Science")
  ];

  List<BookModel> display_list = List.from(main_books_list);

  void updateList(String value) {
    setState(() {
      display_list = main_books_list
          .where((element) =>
          element.book_title!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Corrected color value
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          "Search For Publications",
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 128, 1),
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/home'),
          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 32,),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            TextField(
              onChanged: (value) => updateList(value),
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(155, 237, 255, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(0, 0, 128, 1),
                  ),
                ),
                hintText: "eg: Harry Potter",
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Color.fromRGBO(0, 0, 128, 1),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: display_list.length == 0
                  ? Center(
                child: Text(
                  "No result found",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 128, 1),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: display_list.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: Text(
                    display_list[index].book_title!,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 128, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${display_list[index].author_name!}',
                    style: TextStyle(
                      color: Color.fromRGBO(50, 57, 163, 1),
                    ),
                  ),
                  trailing: Text(
                    '${display_list[index].genre!}',
                    style: TextStyle(
                      color: Color.fromRGBO(88, 71, 173, 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
