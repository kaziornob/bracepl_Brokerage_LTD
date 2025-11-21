import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';

class LatestTransactionsWidget extends StatelessWidget {
  final List<TransactionEntity> transactions;
  const LatestTransactionsWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No recent transactions.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: Icon(
            transaction.type == TransactionType.deposit
                ? Icons.arrow_upward
                : transaction.type == TransactionType.withdraw
                    ? Icons.arrow_downward
                    : Icons.compare_arrows,
            color: transaction.type == TransactionType.deposit
                ? Colors.green
                : transaction.type == TransactionType.withdraw
                    ? Colors.red
                    : Colors.orange,
          ),
          title: Text(transaction.description),
          subtitle: Text(transaction.date.toLocal().toString().split(' ')[0]),
          trailing: Text(
            '${transaction.type == TransactionType.deposit ? '+' : '-'} \$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: transaction.type == TransactionType.deposit
                  ? Colors.green
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
