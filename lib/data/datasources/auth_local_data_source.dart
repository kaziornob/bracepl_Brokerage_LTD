import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getCachedUser();
  Future<void> cacheUser(UserModel userToCache);
  Future<void> clearCache();
}

const CACHED_USER = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getCachedUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);

    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUser(UserModel userToCache) {
    return sharedPreferences.setString(
      CACHED_USER,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<void> clearCache() {
    return sharedPreferences.remove(CACHED_USER);
  }
}
