import 'package:equatable/equatable.dart';
import '../../../../domain/entities/transaction.dart';

abstract class WithdrawState extends Equatable {
  const WithdrawState();

  @override
  List<Object> get props => [];
}

class WithdrawInitial extends WithdrawState {}

class WithdrawLoading extends WithdrawState {}

class WithdrawSuccess extends WithdrawState {
  final TransactionEntity transaction;
  final double newBalance;
  const WithdrawSuccess({required this.transaction, required this.newBalance});

  @override
  List<Object> get props => [transaction, newBalance];
}

class WithdrawError extends WithdrawState {
  final String message;
  const WithdrawError({required this.message});

  @override
  List<Object> get props => [message];
}
