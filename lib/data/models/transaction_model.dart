import '../../domain/entities/transaction.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.type,
    required super.date,
    required super.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'].toDouble(),
      type: _stringToTransactionType(json['type']),
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.toString().split('.').last,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  static TransactionType _stringToTransactionType(String type) {
    switch (type.toLowerCase()) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdraw':
        return TransactionType.withdraw;
      case 'transfer':
        return TransactionType.transfer;
      default:
        throw ArgumentError('Invalid transaction type: $type');
    }
  }
}
