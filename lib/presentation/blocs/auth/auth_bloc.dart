import 'package:bloc/bloc.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/auth/get_session.dart';
import '../../../domain/usecases/auth/login.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final GetSession getSession;

  AuthBloc({
    required this.login,
    required this.getSession,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrUser = await getSession(NoParams());
    emit(failureOrUser.fold(
      (failure) => Unauthenticated(),
      (user) => Authenticated(user: user),
    ));
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrUser = await login(LoginParams(
      email: event.email,
      password: event.password,
    ));
    emit(failureOrUser.fold(
      (failure) => AuthError(message: _mapFailureToMessage(failure)),
      (user) => Authenticated(user: user),
    ));
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    // In a real app, we would also call a logout use case to clear session/token
    emit(Unauthenticated());
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return 'Server Error. Please try again later.';
    } else if (failure is NetworkFailure) {
      return 'No Internet Connection.';
    }
    return 'An unexpected error occurred.';
  }
}
