import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service_locator.dart';
import '../blocs/transaction/withdraw/withdraw_bloc.dart';
import '../blocs/transaction/withdraw/withdraw_event.dart';
import '../blocs/transaction/withdraw/withdraw_state.dart';

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WithdrawBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Withdraw Funds')),
        body: BlocConsumer<WithdrawBloc, WithdrawState>(
          listener: (context, state) {
            if (state is WithdrawError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is WithdrawSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Withdrawal of \$${state.transaction.amount.toStringAsFixed(2)} successful. New balance: \$${state.newBalance.toStringAsFixed(2)}')),
              );
              // context.read<DashboardBloc>().add(GetDashboardData());
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state is WithdrawLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const _WithdrawAmountEntry();
          },
        ),
      ),
    );
  }
}

class _WithdrawAmountEntry extends StatelessWidget {
  const _WithdrawAmountEntry();

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Current Available Balance: \$145,000.00 (Mock Value)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Enter Withdrawal Amount'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0.0;
              if (amount > 0) {
                // context.read<WithdrawBloc>().add(WithdrawConfirmed(amount));
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirm Withdrawal'),
                    content: Text(
                        'Are you sure you want to withdraw \$${amount.toStringAsFixed(2)}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<WithdrawBloc>()
                              .add(WithdrawConfirmed(amount));
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount.')),
                );
              }
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }
}
