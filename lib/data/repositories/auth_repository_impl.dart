import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/util/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getSession() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      return Right(userModel);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
