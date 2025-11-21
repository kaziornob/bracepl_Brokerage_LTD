import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service_locator.dart';
import '../blocs/transaction/deposit/deposit_bloc.dart';
import '../blocs/transaction/deposit/deposit_event.dart';
import '../blocs/transaction/deposit/deposit_state.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DepositBloc>()..add(DepositReset()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Deposit Funds')),
        body: BlocConsumer<DepositBloc, DepositState>(
          listener: (context, state) {
            if (state is DepositError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is DepositSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Deposit of \$${state.transaction.amount.toStringAsFixed(2)} successful!')),
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state is DepositLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DepositAmountEntry) {
              return _AmountEntryView(initialAmount: state.amount);
            } else if (state is DepositConfirmation) {
              return _ConfirmationView(amount: state.amount);
            } else if (state is DepositOTPSent) {
              return _OTPView(amount: state.amount);
            }
            return const Center(child: Text('Transaction Flow Error'));
          },
        ),
      ),
    );
  }
}

class _AmountEntryView extends StatefulWidget {
  final double initialAmount;
  const _AmountEntryView({required this.initialAmount});

  @override
  State<_AmountEntryView> createState() => _AmountEntryViewState();
}

class _AmountEntryViewState extends State<_AmountEntryView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialAmount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter Deposit Amount'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_controller.text) ?? 0.0;
              if (amount > 0) {
                context.read<DepositBloc>().add(DepositAmountEntered(amount));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount.')),
                );
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}


class _ConfirmationView extends StatelessWidget {
  final double amount;
  const _ConfirmationView({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: const Text('Confirm Deposit'),
        content:
            Text('Are you sure you want to deposit \$${amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () {
              context.read<DepositBloc>().add(DepositReset());
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DepositBloc>().add(DepositConfirmed(amount));
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _OTPView extends StatefulWidget {
  final double amount;
  const _OTPView({required this.amount});

  @override
  State<_OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<_OTPView> {
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
              'Enter OTP sent to your phone for deposit of \$${widget.amount.toStringAsFixed(2)}'),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter OTP (Use 123456)'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DepositBloc>().add(DepositOTPEntered(_otpController.text));
            },
            child: const Text('Verify & Complete Deposit'),
          ),
        ],
      ),
    );
  }
}