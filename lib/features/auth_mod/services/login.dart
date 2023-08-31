import 'package:flutter/material.dart';
import '/config/config.dart';
import 'package:dio/dio.dart';
import '../../../core/classes/dio_util.dart';
import 'dart:convert';
import '../models/model.dart';
import '/core/core.dart';
import 'package:flutter/scheduler.dart';

Future<String> registerUser(UserCreate newUser) async {
  final dio = Dio();
  try {
    final response = await dio.post(
      '${ApiEndpoint.baseURL}/register',
      data: newUser.toJson(),
    );
    if (response.statusCode == 200) {
      return '';
    } else if (response.statusCode == 400) {
      return 'Email is already registered. Please use a different email.';
    } else {
      return 'Registration failed. Please try again later.';
    }
  } catch (error) {
    if (error is DioError) {
      final response = error.response;
      return 'Registration failed. ${response?.data['detail'] ?? 'Please try again later.'}';
    } else {
      return 'Registration failed. Please try again later.';
    }
  }
}


Future<String> loginForAccessToken(FormData loginData, BuildContext context) async {
  try {
    // Create Dio instance
    Dio dio = Dio();

    // Make the POST request
    Response response = await dio.post(
      '${ApiEndpoint.baseURL}/login/access-token',
      data: loginData,
    );

    if (response.statusCode == 200) {
      // Successful login

      Token token = Token.fromJson(response.data['access_token']);
      RefreshToken refreshToken = RefreshToken.fromJson(response.data['refresh_token']);


      // Use the access token as needed
      AppCache ac = AppCache();
      ac.doLogin(token.toJson());
      // ac.reLogin(refreshToken.toJson());

      if (await ac.isLogin()) {
        try {
          await getCurrentUserDetails();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Nav.to(context, '/');
            showMessage(context, 'Login Successful');
          });
        } catch (navigateError) {
          print('Error navigating to home: $navigateError');
        }
      }
      return ''; // Return an empty string after successful login
    } else {
      // Error occurred
      return 'Login failed. Please try again later.';
    }
  } catch (error) {
    if (error is DioError) {
      // Handle DioError
      if (error.response != null && error.response!.data != null) {
        return 'Login failed. ${error.response!.data['detail'] ?? 'Please try again later.'}';
      } else {
        return 'Login failed. Please try again later.';
      }
    } else {
      // Handle other errors
      return 'Login failed. Please try again later.';
    }
  }
}


Future<void> getCurrentUserDetails() async {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoint.baseURL));
  // code here
  dio.interceptors.add(AuthInterceptor(dio));
  try {
    final response = await dio.get(
      '/login/me',
    );
    if (response.statusCode == 200) {
      final responseJson = response.data as Map<String, dynamic>;
      final userDetails = UserDetails(
        id: responseJson['id'],
        firstName: responseJson['firstName'],
        lastName: responseJson['lastName'],
        username: responseJson['username'],
        email: responseJson['email'],
        phone: responseJson['phone'],
      );

      await Cache.instance.store('user_details', json.encode(userDetails.toJson()));
    }
  } catch (e) {
    throw Exception('Failed to fetch user details: $e');
  }
}

Future<Token?> getAccessToken() async {
  String? jsonString = await Cache.instance.read('access_token');

  return jsonString != null ? Token.fromJson(json.decode(jsonString)) : null;
}

Future<RefreshToken?> getRefreshToken() async {
  String? jsonString = await Cache.instance.read('refresh_token');

  return jsonString != null
      ? RefreshToken.fromJson(json.decode(jsonString))
      : null;
}

class UserProvider extends ChangeNotifier {
  bool? _isLoggedIn;

  bool? get isLoggedIn => _isLoggedIn;

  UserProvider() {
    // Call CheckLoginStatus() when the UserProvider object is created
    CheckLoginStatus();
  }

  void CheckLoginStatus() async {
    Token? accessToken = await getAccessToken();
    if (accessToken != null) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }
}

class UserDetailsProvider extends ChangeNotifier {
  UserDetails? _details;

  UserDetailsProvider() {
    // Call CheckLoginStatus() when the UserProvider object is created
    loadDetails();
  }

  Future<void> loadDetails() async {
    final userDetails = await Cache.instance.read('user_details');
    //print(userDetails);
    if (userDetails != null) {
      _details = UserDetails.fromJson(json.decode(userDetails));
      notifyListeners();
    }
  }

  UserDetails? get details => _details;
}
