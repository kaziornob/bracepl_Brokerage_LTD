import 'package:bracepl_fund_management/domain/filter_data.dart';
import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchHistoryPage extends HistoryEvent {
  final int pageKey;
  final FilterData filterData;

  const FetchHistoryPage({
    required this.pageKey,
    required this.filterData,
  });

  @override
  List<Object?> get props => [pageKey, filterData];
}

class ApplyFilters extends HistoryEvent {
  final FilterData filterData;

  const ApplyFilters(this.filterData);

  @override
  List<Object?> get props => [filterData];
}

class SetFilter extends HistoryEvent {
  final FilterData filterData;

  const SetFilter(this.filterData);

  @override
  List<Object?> get props => [filterData];
}
