import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Field',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.cyan,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _idController = TextEditingController();

  final _nameFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Field"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Input your name here',
                  ),
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    hintText: 'Input your student ID here',
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter your student ID';
                    }
                    return null;
                  },
                  controller: _idController,
                ),
                SizedBox(height: 20),
                RaisedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.cyan,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // print(_nameController.text);
                        // print(_idController.text);
                        FocusScope.of(context).requestFocus(_nameFocusNode);
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Your name: ${_nameController.text}'),
                                  Text('Your id: ${_idController.text}'),
                                ],
                              ));
                            });
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
