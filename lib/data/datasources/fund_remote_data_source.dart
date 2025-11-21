import 'package:bracepl_fund_management/domain/filter_data.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/transaction.dart';
import '../models/fund_model.dart';
import '../models/transaction_model.dart';

abstract class FundRemoteDataSource {
  Future<FundModel> getFundDetails();
  Future<List<TransactionModel>> getLatestTransactions(int count);
  Future<List<TransactionModel>> getTransactionHistory({
    required int page,
    required int pageSize,
    required FilterData filterData,
  });
  Future<TransactionModel> deposit(double amount);
  Future<TransactionModel> withdraw(double amount);
}

final initialBalance = 150000.50;

class FundRemoteDataSourceImpl implements FundRemoteDataSource {
  // Mock data
  FundModel _mockFund = FundModel(
    id: 'fund_a',
    name: 'BRACEPL Growth Fund',
    currentBalance: initialBalance,
    availableBalance: initialBalance - 5000.00,
    breakdown: {"stocks": 60, "bonds": 30, "cash": 10},
    performanceData: [],
  );

  final List<TransactionModel> _mockTransactions = [
    TransactionModel(
        id: 't1',
        amount: 5000.00,
        type: TransactionType.deposit,
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Initial Deposit'),
    TransactionModel(
        id: 't2',
        amount: 200.00,
        type: TransactionType.withdraw,
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Withdrawal for expenses'),
    TransactionModel(
        id: 't3',
        amount: 1000.00,
        type: TransactionType.deposit,
        date: DateTime.now().subtract(const Duration(days: 5)),
        description: 'Monthly contribution'),
    TransactionModel(
        id: 't4',
        amount: 500.00,
        type: TransactionType.transfer,
        date: DateTime.now().subtract(const Duration(days: 7)),
        description: 'Transfer to savings'),
    TransactionModel(
        id: 't5',
        amount: 100.00,
        type: TransactionType.withdraw,
        date: DateTime.now().subtract(const Duration(days: 10)),
        description: 'Small withdrawal'),
    // Add more mock data for pagination
    ...List.generate(
      50,
      (index) => TransactionModel(
        id: 't${index + 6}',
        amount: (index + 1) * 10.0,
        type: index % 3 == 0
            ? TransactionType.deposit
            : index % 3 == 1
                ? TransactionType.withdraw
                : TransactionType.transfer,
        date: DateTime.now().subtract(Duration(days: 15 + index)),
        description: 'History transaction ${index + 1}',
      ),
    ),
  ];

  void _calculateAndUpdateBalance() {
    double balance = initialBalance;
    _mockFund = _mockFund.copyWith(
        currentBalance: balance,
        availableBalance: balance - 5530.50,
        performanceData: [balance]);
    for (var trxn in _mockTransactions) {
      if (trxn.type == TransactionType.deposit) {
        balance += trxn.amount;
        _mockFund.performanceData.add(balance);
      } else if (trxn.type == TransactionType.withdraw) {
        balance -= trxn.amount;
        _mockFund.performanceData.add(balance);
      }
    }
    _mockFund = _mockFund.copyWith(
        currentBalance: balance, availableBalance: balance - 5530.50);
  }

  @override
  Future<FundModel> getFundDetails() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_mockFund.performanceData.isEmpty) {
      _calculateAndUpdateBalance();
    }
    return _mockFund;
  }

  @override
  Future<List<TransactionModel>> getLatestTransactions(int count) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTransactions.reversed.take(count).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionHistory({
    required int page,
    required int pageSize,
    required FilterData filterData,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Simple filtering logic
    List<TransactionModel> filteredList = _mockTransactions
        .where((t) {
          bool dateMatch = true;
          if (filterData.startDate != null) {
            dateMatch = dateMatch && t.date.isAfter(filterData.startDate!);
          }
          if (filterData.endDate != null) {
            dateMatch = dateMatch && t.date.isBefore(filterData.endDate!);
          }
          bool typeMatch = filterData.type == null || t.type == filterData.type;
          return dateMatch && typeMatch;
        })
        .toList()
        .reversed
        .toList();

    // Simple pagination logic
    final startIndex = (page - 1) * pageSize;
    if (startIndex >= filteredList.length) {
      return []; // End of list
    }
    final endIndex = startIndex + pageSize;
    return filteredList.sublist(startIndex,
        endIndex > filteredList.length ? filteredList.length : endIndex);
  }

  @override
  Future<TransactionModel> deposit(double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    if (amount <= 0) {
      throw const TransactionException(
          message: 'Deposit amount must be positive.');
    }

    // Mock successful deposit
    final trxn = TransactionModel(
      id: 'dep_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      type: TransactionType.deposit,
      date: DateTime.now(),
      description: 'Successful deposit',
    );

    _mockTransactions.add(trxn); // Add to the top of the list
    _calculateAndUpdateBalance();
    return trxn;
  }

  @override
  Future<TransactionModel> withdraw(double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    if (amount > _mockFund.availableBalance) {
      throw const TransactionException(
          message: 'Withdrawal amount exceeds available balance.');
    }

    // Mock successful withdrawal
    final trxn = TransactionModel(
      id: 'wth_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      type: TransactionType.withdraw,
      date: DateTime.now(),
      description: 'Successful withdrawal',
    );
    _mockTransactions.add(trxn); // Add to the top of the list
    _calculateAndUpdateBalance();
    return trxn;
  }
}
