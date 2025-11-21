import 'package:bracepl_fund_management/domain/filter_data.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction.dart';

class HistoryState extends Equatable {
  final List<TransactionEntity> transactions;
  final bool loadingState;
  final bool hasReachedMax;
  final int currentPage;
  final FilterData filterData;

  const HistoryState({
    required this.loadingState,
    required this.transactions,
    required this.hasReachedMax,
    required this.currentPage,
    required this.filterData,
  });
  factory HistoryState.initial() {
    return HistoryState(
      loadingState: false,
      transactions: [],
      hasReachedMax: false,
      currentPage: 0,
      filterData: const FilterData(),
    );
  }

  factory HistoryState.initialLoading() {
    return HistoryState(
      loadingState: true,
      transactions: [],
      hasReachedMax: false,
      currentPage: 0,
      filterData: const FilterData(),
    );
  }

  HistoryState copyWith({
    List<TransactionEntity>? transactions,
    bool? loadingState,
    bool? hasReachedMax,
    int? currentPage,
    FilterData? filterData,
  }) {
    return HistoryState(
      loadingState: loadingState ?? this.loadingState,
      transactions: transactions ?? this.transactions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      filterData: filterData ?? this.filterData,
    );
  }

  @override
  List<Object> get props => [
        transactions,
        hasReachedMax,
        currentPage,
        filterData,
        loadingState,
      ];
}
