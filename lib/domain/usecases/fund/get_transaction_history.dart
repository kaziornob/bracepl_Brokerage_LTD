import 'package:bracepl_fund_management/domain/filter_data.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/transaction.dart';
import '../../repositories/fund_repository.dart';

class GetTransactionHistory
    implements UseCase<List<TransactionEntity>, GetTransactionHistoryParams> {
  final FundRepository repository;

  GetTransactionHistory(this.repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(
      GetTransactionHistoryParams params) async {
    return await repository.getTransactionHistory(
      page: params.page,
      pageSize: params.pageSize,
      filterData: params.filterData,
    );
  }
}

class GetTransactionHistoryParams extends Equatable {
  final int page;
  final int pageSize;
  final FilterData filterData;

  const GetTransactionHistoryParams({
    required this.page,
    required this.pageSize,
    required this.filterData,
  });

  @override
  List<Object?> get props => [page, pageSize, filterData];
}
