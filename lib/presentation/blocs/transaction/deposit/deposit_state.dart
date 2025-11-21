import 'package:equatable/equatable.dart';
import '../../../../domain/entities/transaction.dart';

abstract class DepositState extends Equatable {
  const DepositState();

  @override
  List<Object> get props => [];
}

class DepositInitial extends DepositState {}

class DepositAmountEntry extends DepositState {
  final double amount;
  const DepositAmountEntry({this.amount = 0.0});

  @override
  List<Object> get props => [amount];
}

class DepositConfirmation extends DepositState {
  final double amount;
  const DepositConfirmation({required this.amount});

  @override
  List<Object> get props => [amount];
}

class DepositOTPSent extends DepositState {
  final double amount;
  const DepositOTPSent({required this.amount});

  @override
  List<Object> get props => [amount];
}

class DepositLoading extends DepositState {}

class DepositSuccess extends DepositState {
  final TransactionEntity transaction;
  const DepositSuccess({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class DepositError extends DepositState {
  final String message;
  final DepositState previousState;
  const DepositError({required this.message, required this.previousState});

  @override
  List<Object> get props => [message, previousState];
}
