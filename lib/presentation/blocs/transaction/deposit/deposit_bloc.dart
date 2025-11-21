import 'package:bloc/bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/usecases/fund/deposit.dart';
import 'deposit_event.dart';
import 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  final Deposit depositUseCase;

  DepositBloc({required this.depositUseCase}) : super(DepositInitial()) {
    on<DepositAmountEntered>(_onAmountEntered);
    on<DepositConfirmed>(_onConfirmed);
    on<DepositOTPEntered>(_onOTPEntered);
    on<DepositReset>(_onReset);
  }

  void _onAmountEntered(
      DepositAmountEntered event, Emitter<DepositState> emit) {
    emit(DepositConfirmation(amount: event.amount));
  }

  void _onConfirmed(DepositConfirmed event, Emitter<DepositState> emit) {
    // In a real app, this would trigger the OTP sending process
    emit(DepositOTPSent(amount: event.amount));
  }

  void _onOTPEntered(DepositOTPEntered event, Emitter<DepositState> emit) async {
    // In a real app, this would validate OTP before proceeding
    if (event.otp != '123456') {
      emit(DepositError(
          message: 'Invalid OTP. Please try again.',
          previousState: DepositOTPSent(amount: (state as DepositOTPSent).amount)));
      return;
    }

    final amount = (state as DepositOTPSent).amount;
    emit(DepositLoading());

    final result = await depositUseCase(DepositParams(amount: amount));

    result.fold(
      (failure) => emit(DepositError(
          message: _mapFailureToMessage(failure),
          previousState: DepositOTPSent(amount: amount))),
      (transaction) => emit(DepositSuccess(transaction: transaction)),
    );
  }

  void _onReset(DepositReset event, Emitter<DepositState> emit) {
    emit(DepositAmountEntry());
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is TransactionFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return 'Server Error. Deposit failed.';
    } else if (failure is NetworkFailure) {
      return 'No Internet Connection.';
    }
    return 'An unexpected error occurred.';
  }
}
