import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/transaction.dart';
import '../../repositories/fund_repository.dart';

class Withdraw implements UseCase<TransactionEntity, WithdrawParams> {
  final FundRepository repository;

  Withdraw(this.repository);

  @override
  Future<Either<Failure, TransactionEntity>> call(WithdrawParams params) async {
    return await repository.withdraw(params.amount);
  }
}

class WithdrawParams extends Equatable {
  final double amount;

  const WithdrawParams({required this.amount});

  @override
  List<Object> get props => [amount];
}
