import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swa/core/error/exceptions.dart';
import 'package:swa/core/utils/app_strings.dart';
import 'package:swa/features/sign_in/data/models/user_response_model.dart';

abstract class LoginLocalDataSource{
  Future<UserResponseModel> getLastUserLoginData();
  Future<void> cacheUserData(UserResponseModel applicantModel);
  Future<void> clearUserData();
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource{
  final SharedPreferences sharedPreferences;
  LoginLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserResponseModel> getLastUserLoginData() {
    final jsonString = sharedPreferences.getString(AppStrings.cachedUserLoginData);
    if(jsonString != null && jsonString != ''){
      final cachedUserData = Future.value(UserResponseModel.fromJson(json.decode(jsonString)));
      return cachedUserData;
    }else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUserData(UserResponseModel userResponseModel) {
    return sharedPreferences.setString(AppStrings.cachedUserLoginData, json.encode(userResponseModel));
  }

  @override
  Future<void> clearUserData() {
    return sharedPreferences.setString(AppStrings.cachedUserLoginData, '');
  }
}