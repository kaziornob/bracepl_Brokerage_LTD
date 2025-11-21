import 'package:equatable/equatable.dart';

abstract class DepositEvent extends Equatable {
  const DepositEvent();

  @override
  List<Object> get props => [];
}

class DepositAmountEntered extends DepositEvent {
  final double amount;

  const DepositAmountEntered(this.amount);

  @override
  List<Object> get props => [amount];
}

class DepositConfirmed extends DepositEvent {
  final double amount;

  const DepositConfirmed(this.amount);

  @override
  List<Object> get props => [amount];
}

class DepositOTPEntered extends DepositEvent {
  final String otp;

  const DepositOTPEntered(this.otp);

  @override
  List<Object> get props => [otp];
}

class DepositReset extends DepositEvent {}
