import 'package:bloc/bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/usecases/fund/withdraw.dart';
import 'withdraw_event.dart';
import 'withdraw_state.dart';

class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
  final Withdraw withdrawUseCase;

  // This is a simplified approach. In a real app, the balance would come from a FundBloc or similar.
  // For the purpose of this mock, we'll use a hardcoded mock balance.
  double _mockCurrentBalance = 150000.50;

  WithdrawBloc({required this.withdrawUseCase}) : super(WithdrawInitial()) {
    on<WithdrawConfirmed>(_onConfirmed);
    on<WithdrawReset>((event, emit) => emit(WithdrawInitial()));
  }

  void _onConfirmed(
      WithdrawConfirmed event, Emitter<WithdrawState> emit) async {
    emit(WithdrawLoading());

    // Logic to validate withdrawal limits (simplified: check against mock balance)
    if (event.amount > _mockCurrentBalance) {
      emit(const WithdrawError(
          message: 'Withdrawal amount exceeds available balance.'));
      return;
    }

    final result = await withdrawUseCase(WithdrawParams(amount: event.amount));

    result.fold(
      (failure) => emit(WithdrawError(message: _mapFailureToMessage(failure))),
      (transaction) {
        // Update the mock balance after successful transaction
        _mockCurrentBalance -= transaction.amount;
        emit(WithdrawSuccess(
            transaction: transaction, newBalance: _mockCurrentBalance));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is TransactionFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return 'Server Error. Withdrawal failed.';
    } else if (failure is NetworkFailure) {
      return 'No Internet Connection.';
    }
    return 'An unexpected error occurred.';
  }
}
