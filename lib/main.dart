import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/chart.dart';

import './widgets/new_trans.dart';
import './widgets/trans_list.dart';
import './model/transaction.dart';
import './widgets/chart.dart';

// import 'package:personal_expenses/model/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses Apps',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.tealAccent,
        // errorColor: Colors.red,
        fontFamily: 'cabin',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                fontFamily: 'cabin',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              // button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'cabin', fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: expensesApp(),
    );
  }
}

class expensesApp extends StatefulWidget {
  @override
  _expensesAppState createState() => _expensesAppState();
}

class _expensesAppState extends State<expensesApp> {
  // late String titleInput;
  final List<Transaction> _userTrans = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 100.50,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'New Flip-FLop',
    //   amount: 60.50,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransaction {
    return _userTrans.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addnewTransaction(
      String txTitle, double txAmount, DateTime choosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: choosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTrans.add(newTx);
    });
  }

  void _startNewTrans(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        // return NewTrans(_addnewTransaction);
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTrans(_addnewTransaction),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTrans.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Expenses Apps'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startNewTrans(context),
        )
      ],
      centerTitle: true,
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.4,
                child: Chart(_recentTransaction)),
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.6,
                child: TrnasList(_userTrans, _deleteTransaction)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startNewTrans(context),
      ),
    );
  }
}
