// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api, avoid_print, duplicate_ignore, avoid_init_to_null

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../widgets/adaptive_flat_button.dart';

class NewTrans extends StatefulWidget {
  final Function addTx;

  NewTrans(this.addTx, {super.key}) {
    // ignore: avoid_print
    print('Construct newTrans Widgate');
  }

  @override
  _NewTransState createState() {
    print('Createstate newTrans Widgate');
    return _NewTransState();
  }
}

class _NewTransState extends State<NewTrans> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate = null;

  _NewTransState() {
    print('Constract newTrans State');
  }

  @override
  void initState() {
    print('InitState()');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTrans oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 3,
        child: Container(
          margin: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (value) {
                //   titleInput = value;
                // },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (value) => amountInput = value,
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Choosen!'
                            : 'Picked Date : ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date!', _presentDatePicker)
                  ],
                ),
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _submitData,
                      child: const Text(
                        'Add Transaction',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _submitData,
                      child: const Text(
                        'Add Transaction',
                        style: TextStyle(
                          color: Colors.white,
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
