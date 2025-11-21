import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/util/network_info.dart';


// Data Sources
import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/fund_remote_data_source.dart';

// Repositories
import 'domain/repositories/auth_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/fund_repository.dart';
import 'data/repositories/fund_repository_impl.dart';

// Use Cases - Auth
import 'domain/usecases/auth/login.dart';
import 'domain/usecases/auth/get_session.dart';

// Use Cases - Fund
import 'domain/usecases/fund/get_fund_details.dart';
import 'domain/usecases/fund/get_latest_transactions.dart';
import 'domain/usecases/fund/get_transaction_history.dart';
import 'domain/usecases/fund/deposit.dart';
import 'domain/usecases/fund/withdraw.dart';

// Blocs
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/dashboard/dashboard_bloc.dart';
import 'presentation/blocs/history/history_bloc.dart';
import 'presentation/blocs/transaction/deposit/deposit_bloc.dart';
import 'presentation/blocs/transaction/withdraw/withdraw_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth & Fund Management

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      getSession: sl(),
    ),
  );
  sl.registerFactory(
    () => DashboardBloc(
      getFundDetails: sl(),
      getLatestTransactions: sl(),
    ),
  );
  sl.registerFactory(
    () => HistoryBloc(
      getTransactionHistory: sl(),
    ),
  );
  sl.registerFactory(
    () => DepositBloc(
      depositUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => WithdrawBloc(
      withdrawUseCase: sl(),
    ),
  );

  // Use cases - Auth
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetSession(sl()));

  // Use cases - Fund
  sl.registerLazySingleton(() => GetFundDetails(sl()));
  sl.registerLazySingleton(() => GetLatestTransactions(sl()));
  sl.registerLazySingleton(() => GetTransactionHistory(sl()));
  sl.registerLazySingleton(() => Deposit(sl()));
  sl.registerLazySingleton(() => Withdraw(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<FundRemoteDataSource>(
    () => FundRemoteDataSourceImpl(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
