// ignore_for_file: camel_case_types, override_on_non_overriding_member, avoid_print, sort_child_properties_last

import 'dart:io';
import 'package:flutter/cupertino.dart';


import 'package:flutter/material.dart';

import 'package:personal_expenses/widgets/chart.dart';

import './widgets/new_trans.dart';
import './widgets/trans_list.dart';
import './model/transaction.dart';


// import 'package:personal_expenses/model/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown ,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses Apps',
      theme: ThemeData(
        fontFamily: 'cabin',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontFamily: 'cabin',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              // button: TextStyle(color: Colors.white),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'cabin', fontSize: 20, fontWeight: FontWeight.bold),
        ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(secondary: Colors.tealAccent),
      ),
      home: const expensesApp(),
    );
  }
}

class expensesApp extends StatefulWidget {
  const expensesApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _expensesAppState createState() => _expensesAppState();
}

class _expensesAppState extends State<expensesApp> with WidgetsBindingObserver {
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

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  didChangeAppLifecycState(AppLifecycleState state) {
   print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransaction {
    return _userTrans.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
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

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidgate,
  ) {
    return [
      Row(
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.primary,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.6,
              child: Chart(_recentTransaction))
          : txListWidgate
    ];
  }

  List<Widget> _buildPotraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidgate,
  ) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransaction),
      ),
      txListWidgate
    ];
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              'Expenses Apps',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startNewTrans(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text('Expenses Apps'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startNewTrans(context),
              )
            ],
            centerTitle: true,
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = _buildAppBar();
    final txListWidgate = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TrnasList(_userTrans, _deleteTransaction));
    final pageBody = SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            ..._buildLandscapeContent(
              mediaQuery,
              appBar,
              txListWidgate,
            ),
          if (!isLandscape)
            ..._buildPotraitContent(
              mediaQuery,
              appBar,
              txListWidgate,
            ),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startNewTrans(context),
                  ),
          );
  }
}
