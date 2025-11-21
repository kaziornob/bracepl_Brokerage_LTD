import 'package:bracepl_fund_management/domain/filter_data.dart';
import 'package:bracepl_fund_management/presentation/widgets/filter_transaction_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service_locator.dart';
import '../blocs/history/history_bloc.dart';
import '../blocs/history/history_event.dart';
import '../blocs/history/history_state.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late HistoryBloc _historyBloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _historyBloc = sl<HistoryBloc>();
    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);

    // Load initial page
    _historyBloc.add(const FetchHistoryPage(
      pageKey: 1,
      filterData: FilterData(),
    ));
  }

  void _onScroll() {
    if (_isBottom &&
        !_historyBloc.state.hasReachedMax &&
        !_historyBloc.state.loadingState) {
      final nextPage = _historyBloc.state.currentPage + 1;
      print('Loading next page: $nextPage');
      // Set loading state first
      _historyBloc.add(FetchHistoryPage(
        pageKey: nextPage,
        filterData: _historyBloc.state.filterData,
      ));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryBloc>.value(
      value: _historyBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction History'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => BlocProvider.value(
                      value: _historyBloc, child: FilterBottomSheet()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            print(
                'Building with state: Page ${state.currentPage}, Loading: ${state.loadingState}, HasReachedMax: ${state.hasReachedMax}, Transactions count: ${state.transactions.length}');

            if (state.currentPage == 0 && state.loadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.transactions.isEmpty && !state.loadingState) {
              return const Center(child: Text('No transactions found.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                print('Refreshing transaction history');
                _historyBloc.add(FetchHistoryPage(
                  pageKey: 1,
                  filterData: state.filterData,
                ));
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final item = state.transactions[index];
                        return ListTile(
                          title: Text(
                              '${item.type.name.toUpperCase()}: \$${item.amount.toStringAsFixed(2)}'),
                          subtitle: Text(item.description),
                          trailing: Text(
                              item.date.toLocal().toString().split(' ')[0]),
                        );
                      },
                    ),
                  ),
                  if (state.transactions.isNotEmpty && state.loadingState)
                    const LinearProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
