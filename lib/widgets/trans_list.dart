import 'package:flutter/material.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';

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
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\$${transaction[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transaction[index].title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(transaction[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? TextButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.error),
                          onPressed: () => deleteTx(transaction[index].id),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).colorScheme.error,
                          onPressed: () => deleteTx(transaction[index].id),
                        ),
                ),
              );
            },
            itemCount: transaction.length,
          );
  }
}
