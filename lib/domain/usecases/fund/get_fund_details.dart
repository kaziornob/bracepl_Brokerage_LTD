import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/fund.dart';
import '../../repositories/fund_repository.dart';

class GetFundDetails implements UseCase<FundEntity, NoParams> {
  final FundRepository repository;

  GetFundDetails(this.repository);

  @override
  Future<Either<Failure, FundEntity>> call(NoParams params) async {
    return await repository.getFundDetails();
  }
}
