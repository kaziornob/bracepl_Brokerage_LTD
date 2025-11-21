import 'package:equatable/equatable.dart';

enum TransactionType { deposit, withdraw, transfer }

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String description;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.description,
  });

  @override
  List<Object> get props => [id, amount, type, date, description];
}
