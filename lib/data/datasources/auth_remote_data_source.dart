import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final UserModel _mockUser = const UserModel(
    id: 'user_123',
    email: 'test@bracepl.com',
    name: 'Kazi Ornob',
  );

  @override
  Future<UserModel> login(String email, String password) async {

    await Future.delayed(const Duration(seconds: 1));

    if (email == 'test@bracepl.com' && password == 'password') {
      return _mockUser;
    } else if (email == 'error@bracepl.com') {
      throw ServerException(message: 'Server error during login.');
    } else {
      throw AuthException(message: 'Invalid credentials.');
    }
  }
}
