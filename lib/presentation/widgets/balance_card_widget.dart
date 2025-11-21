import 'package:bracepl_fund_management/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:bracepl_fund_management/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/fund.dart';
import '../pages/deposit_page.dart';
import '../pages/withdraw_page.dart';

class BalanceCardWidget extends StatelessWidget {
  final FundEntity fund;
  const BalanceCardWidget({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Balance',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              '\$${fund.currentBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Balance:',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '\$${fund.availableBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.add_circle_outline,
                  label: 'Deposit',
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const DepositPage()),
                    );
                    if (context.mounted) {
                      context.read<DashboardBloc>().add(GetDashboardData());
                    }
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.remove_circle_outline,
                  label: 'Withdraw',
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const WithdrawPage()),
                    );
                    if (context.mounted) {
                      context.read<DashboardBloc>().add(GetDashboardData());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
