import 'package:bracepl_fund_management/domain/filter_data.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/fund.dart';
import '../entities/transaction.dart';

abstract class FundRepository {
  Future<Either<Failure, FundEntity>> getFundDetails();
  Future<Either<Failure, List<TransactionEntity>>> getLatestTransactions(
      int count);
  Future<Either<Failure, List<TransactionEntity>>> getTransactionHistory({
    required int page,
    required int pageSize,
    required FilterData filterData,
  });
  Future<Either<Failure, TransactionEntity>> deposit(double amount);
  Future<Either<Failure, TransactionEntity>> withdraw(double amount);
}
