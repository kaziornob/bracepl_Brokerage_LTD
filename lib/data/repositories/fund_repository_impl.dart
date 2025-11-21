import 'package:bracepl_fund_management/domain/filter_data.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/util/network_info.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/fund_repository.dart';
import '../datasources/fund_remote_data_source.dart';

class FundRepositoryImpl implements FundRepository {
  final FundRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FundRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _executeRemoteCall<T>(
      Future<T> Function() remoteCall) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteCall();
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      } on TransactionException catch (e) {
        return Left(TransactionFailure(e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, FundEntity>> getFundDetails() {
    return _executeRemoteCall(() => remoteDataSource.getFundDetails());
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getLatestTransactions(
      int count) {
    return _executeRemoteCall(
        () => remoteDataSource.getLatestTransactions(count));
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionHistory({
    required int page,
    required int pageSize,
    required FilterData filterData,
  }) {
    return _executeRemoteCall(() => remoteDataSource.getTransactionHistory(
          page: page,
          pageSize: pageSize,
          filterData: filterData,
        ));
  }

  @override
  Future<Either<Failure, TransactionEntity>> deposit(double amount) {
    return _executeRemoteCall(() => remoteDataSource.deposit(amount));
  }

  @override
  Future<Either<Failure, TransactionEntity>> withdraw(double amount) {
    return _executeRemoteCall(() => remoteDataSource.withdraw(amount));
  }
}
