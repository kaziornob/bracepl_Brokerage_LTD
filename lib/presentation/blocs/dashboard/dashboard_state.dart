import 'package:equatable/equatable.dart';
import '../../../domain/entities/fund.dart';
import '../../../domain/entities/transaction.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final FundEntity fund;
  final List<TransactionEntity> latestTransactions;

  const DashboardLoaded({required this.fund, required this.latestTransactions});

  @override
  List<Object> get props => [fund, latestTransactions];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
