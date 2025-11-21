import 'package:bracepl_fund_management/domain/entities/transaction.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FilterData extends Equatable {
  final TransactionType? type;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterData({this.type, this.startDate, this.endDate});

  FilterData copyWith({
    ValueGetter<TransactionType?>? type,
    ValueGetter<DateTime?>? startDate,
    ValueGetter<DateTime?>? endDate,
  }) {
    return FilterData(
      type: type != null ? type() : this.type,
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
    );
  }

  @override
  List<Object?> get props => [type, startDate, endDate];
}
