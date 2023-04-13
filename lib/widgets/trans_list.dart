import 'package:flutter/material.dart';
import '../model/transaction.dart';
// import 'package:intl/intl.dart';
import 'transaction_item.dart';

class TrnasList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;

  TrnasList(this.transaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: [
                Text(
                  'No transaction added yet',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraint.maxHeight * 0.3,
                  child: Image.asset(
                    'assets/images/ic_dada.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionItem(
                transaction: transaction[index],
                deleteTx: deleteTx,
              );
            },
            itemCount: transaction.length,
          );
  }
}
