import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/transaction.dart';
import '../../repositories/fund_repository.dart';

class Deposit implements UseCase<TransactionEntity, DepositParams> {
  final FundRepository repository;

  Deposit(this.repository);

  @override
  Future<Either<Failure, TransactionEntity>> call(DepositParams params) async {
    return await repository.deposit(params.amount);
  }
}

class DepositParams extends Equatable {
  final double amount;

  const DepositParams({required this.amount});

  @override
  List<Object?> get props => [amount];
}
