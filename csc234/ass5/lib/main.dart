import 'package:flutter/material.dart';

void main() {
  runApp(BooksApp());
}

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  String _selectedBook = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books App',
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('BooksListPage'),
            child: BooksListScreen(
              onTapped: _handleBookTapped,
            ),
          ),
          if (_selectedBook == 'text01')
            BookDetailsOnePage(book: _selectedBook)
          else if (_selectedBook == 'text02')
            BookDetailsTwoPage(book: _selectedBook)
          else if (_selectedBook == 'error')
            BookDetailsErrorPage()
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          // Update the list of pages by setting _selectedBook to null
          setState(() {
            _selectedBook = '';
          });

          return true;
        },
      ),
    );
  }

  void _handleBookTapped(String text) {
    if (text != 'text01' && text != 'text02') {
      text = 'error';
    }
    // print(text);
    setState(() {
      _selectedBook = text;
    });
  }
}

class BookDetailsOnePage extends Page {
  final String book;

  BookDetailsOnePage({
    this.book,
  }) : super(key: ValueKey(book));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return BookDetailsScreen(book);
      },
    );
  }
}

class BookDetailsTwoPage extends Page {
  final String book;

  BookDetailsTwoPage({
    this.book,
  }) : super(key: ValueKey(book));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return BookDetailsScreen(book);
      },
    );
  }
}

class BookDetailsErrorPage extends Page {
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return BookDetailsScreen('Error 404 page not found');
      },
    );
  }
}

class BooksListScreen extends StatefulWidget {
  final ValueChanged<String> onTapped;

  BooksListScreen({
    @required this.onTapped,
  });

  @override
  _BooksListScreenState createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Main Screen')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) return 'Please enter something';
                    return null;
                  },
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Input',
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate())
                    widget.onTapped(_nameController.text);
                  _nameController.text = '';
                },
                child: Text(
                  'Click Me',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.pink,
              )
            ],
          ),
        ));
  }
}

class BookDetailsScreen extends StatelessWidget {
  final String text;
  BookDetailsScreen(this.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
