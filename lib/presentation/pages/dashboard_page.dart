import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service_locator.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/dashboard/dashboard_event.dart';
import '../blocs/dashboard/dashboard_state.dart';
import '../widgets/latest_transactions_widget.dart';
import '../widgets/balance_card_widget.dart';
import 'fund_details_page.dart';
import 'transaction_history_page.dart';



class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()..add(GetDashboardData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TransactionHistoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () {
                  context.read<DashboardBloc>().add(GetDashboardData());
                  return context.read<DashboardBloc>().stream.firstWhere(
                      (state) => state is DashboardLoaded || state is DashboardError);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BalanceCardWidget(fund: state.fund),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('Fund Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FundDetailsPage(fund: state.fund),
                            ),
                          );
                          if (result == true && context.mounted) {
                            context.read<DashboardBloc>().add(GetDashboardData());
                          }
                        },
                          ),
                      const Divider(),
                      const Text('Latest 10 Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      LatestTransactionsWidget(transactions: state.latestTransactions),
                    ],
                  ),
                ),
              );
            } else if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(GetDashboardData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Welcome to BRACEPL Fund Management'));
          },
        ),
      ),
    );
  }
}
