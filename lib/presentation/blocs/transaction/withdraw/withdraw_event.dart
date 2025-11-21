import 'package:equatable/equatable.dart';

abstract class WithdrawEvent extends Equatable {
  const WithdrawEvent();

  @override
  List<Object> get props => [];
}

class WithdrawAmountEntered extends WithdrawEvent {
  final double amount;

  const WithdrawAmountEntered(this.amount);

  @override
  List<Object> get props => [amount];
}

class WithdrawConfirmed extends WithdrawEvent {
  final double amount;

  const WithdrawConfirmed(this.amount);

  @override
  List<Object> get props => [amount];
}

class WithdrawReset extends WithdrawEvent {}
