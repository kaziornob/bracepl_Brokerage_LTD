import 'package:bloc/bloc.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/fund/get_fund_details.dart';
import '../../../domain/usecases/fund/get_latest_transactions.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetFundDetails getFundDetails;
  final GetLatestTransactions getLatestTransactions;

  DashboardBloc({
    required this.getFundDetails,
    required this.getLatestTransactions,
  }) : super(DashboardInitial()) {
    on<GetDashboardData>(_onGetDashboardData);
  }

  void _onGetDashboardData(
      GetDashboardData event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final fundResult = await getFundDetails(NoParams());
    final transactionsResult =
        await getLatestTransactions(const GetLatestTransactionsParams(count: 10));

    fundResult.fold(
      (fundFailure) {
        emit(DashboardError(message: _mapFailureToMessage(fundFailure)));
      },
      (fund) {
        transactionsResult.fold(
          (transFailure) {
            // Even if transactions fail, we can still show fund details
            emit(DashboardLoaded(fund: fund, latestTransactions: const []));
          },
          (transactions) {
            emit(DashboardLoaded(fund: fund, latestTransactions: transactions));
          },
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Error. Could not load dashboard data.';
    } else if (failure is NetworkFailure) {
      return 'No Internet Connection.';
    }
    return 'An unexpected error occurred.';
  }
}
