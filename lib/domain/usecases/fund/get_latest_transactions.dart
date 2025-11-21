import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/transaction.dart';
import '../../repositories/fund_repository.dart';

class GetLatestTransactions implements UseCase<List<TransactionEntity>, GetLatestTransactionsParams> {
  final FundRepository repository;

  GetLatestTransactions(this.repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(GetLatestTransactionsParams params) async {
    return await repository.getLatestTransactions(params.count);
  }
}

class GetLatestTransactionsParams extends Equatable {
  final int count;

  const GetLatestTransactionsParams({required this.count});

  @override
  List<Object> get props => [count];
}
