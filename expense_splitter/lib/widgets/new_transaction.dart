import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransaction;
  NewTransaction(this.newTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // Input Controller
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    // Get input from controller
    final _enteredTitle = titleController.text;
    final _enteredAmount = double.parse(amountController.text);
    final _enteredDate = _selectedDate;

    // Validation
    if (_enteredTitle.isEmpty || _enteredAmount <= 0 || _selectedDate == null)
      return;

    // Access stateful class from state class
    widget.newTransaction(_enteredTitle, _enteredAmount, _enteredDate);

    // Turn off modal sheets
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData,
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                  ),
                  // Platform.isIOS
                  //     ? CupertinoButton(
                  //         child: Text(
                  //           'Choose Date',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //         onPressed: _presentDatePicker,
                  //       )
                  //     : FlatButton(
                  //         textColor: Theme.of(context).primaryColor,
                  //         child: Text(
                  //           'Choose Date',
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //         onPressed: _presentDatePicker,
                  //       )
                  AdaptiveButton('Choose Date!', _presentDatePicker)
                ],
              ),
            ),
            RaisedButton(
              onPressed: _submitData,
              child: Text('Add Transaction'),
              textColor: Theme.of(context).textTheme.button.color,
              color: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
