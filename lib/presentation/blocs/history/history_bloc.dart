import 'package:bloc/bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/fund/get_transaction_history.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetTransactionHistory getTransactionHistory;
  static const int _pageSize = 20;

  HistoryBloc({required this.getTransactionHistory})
      : super(HistoryState.initial()) {
    on<FetchHistoryPage>(_onFetchHistoryPage);
    on<ApplyFilters>(_onApplyFilters);
    on<SetFilter>(_setFilter);
  }

  void _setFilter(SetFilter event, Emitter<HistoryState> emit) {
    emit(state.copyWith(filterData: event.filterData));
  }

  void _onApplyFilters(ApplyFilters event, Emitter<HistoryState> emit) {
    // Clear existing data first
    emit(state.copyWith(
      transactions: [],
      currentPage: 0,
      hasReachedMax: false,
      filterData: event.filterData,
      loadingState: true,
    ));
    // Then fetch fresh data
    add(FetchHistoryPage(
      pageKey: 1,
      filterData: event.filterData,
    ));
  }

  void _onFetchHistoryPage(
      FetchHistoryPage event, Emitter<HistoryState> emit) async {
    // Check for max reached (but allow if starting from page 1)
    if (state.hasReachedMax && event.pageKey != 1) {
      return;
    }

    final currentState = state;
    final isInitialLoad = state.currentPage == 0 || event.pageKey == 1;

    // Determine if the filter criteria has changed and we need a full reset
    final isFilterChange =
        event.pageKey == 1 && currentState.filterData != event.filterData;

    // Emit loading state if it's the first time or filters changed
    if (isInitialLoad || isFilterChange) {
      print('Setting loading state for initial load or filter change');
      emit(state.copyWith(
        loadingState: true,
        transactions: isFilterChange ? [] : state.transactions,
        currentPage: isFilterChange ? 0 : state.currentPage,
      ));
    } else {
      // Loading more pages
      emit(state.copyWith(loadingState: true));
    }

    final page = event.pageKey;
    final result = await getTransactionHistory(GetTransactionHistoryParams(
      page: page,
      pageSize: _pageSize,
      filterData: event.filterData,
    ));
    print('Received result for page $page with filters: ${event.filterData}');

    result.fold(
      (failure) {
        emit(state.copyWith(
          loadingState: false,
        ));
        // You might want to add an error field to HistoryState
        print('Error: ${_mapFailureToMessage(failure)}');
      },
      (newTransactions) {
        final previousTransactions = state.transactions;

        // Determine if we should completely reset the list
        final shouldResetList = isInitialLoad || isFilterChange;

        print('Previous transactions count: ${previousTransactions.length}');
        print('New transactions count: ${newTransactions.length}');
        print('Should reset list: $shouldResetList');

        final transactions = shouldResetList
            ? newTransactions
            : previousTransactions + newTransactions;

        final hasReachedMax = newTransactions.length < _pageSize;

        emit(state.copyWith(
          transactions: transactions,
          hasReachedMax: hasReachedMax,
          currentPage: page,
          filterData: event.filterData,
          loadingState: false,
        ));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Error. Could not load transaction history.';
    } else if (failure is NetworkFailure) {
      return 'No Internet Connection.';
    }
    return 'An unexpected error occurred.';
  }
}
