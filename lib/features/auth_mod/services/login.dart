import 'package:flutter/material.dart';
import '/config/config.dart';
import '../../goal_app/services/storage.dart';
import 'package:dio/dio.dart';
import '../../goal_app/services/dio_util.dart';
import 'dart:convert';
import '../models/model.dart';

Future<String> registerUser(UserCreate newUser) async {
  final dio = Dio();
  try {
    final response = await dio.post(
      '$ApiEndpoint.baseURL/register',
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

Future<String> loginForAccessToken(FormData loginData) async {
  try {
    // Create Dio instance
    Dio dio = Dio();

    // Make the POST request
    Response response =
        await dio.post('${ApiEndpoint.baseURL}/login/access-token', data: loginData);
    // Handle the response
    if (response.statusCode == 200) {
      // Successful login

      Token token = Token.fromJson(response.data['access_token']);
      RefreshToken refreshToken =
          RefreshToken.fromJson(response.data['refresh_token']);

      SecureStorage storage = SecureStorage.instance;

      await storage.store('access_token', json.encode(token.toJson()));
      await storage.store('refresh_token', json.encode(refreshToken.toJson()));

      await getCurrentUserDetails();
      // Use the access token as needed
      return '';
    } else {
      // Error occurred
      return 'Login failed. Please try again later.';
    }
  } catch (error) {
    if (error is DioError) {
      //final response = error.response;
      return 'Login failed. Please try again later.'; // ${response?.data['detail'] ?? 'Please try again later.'}';
    } else {
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
      SecureStorage storage = SecureStorage.instance;
      await storage.store('user_details', json.encode(userDetails.toJson()));
    }
  } catch (e) {
    throw Exception('Failed to fetch user details: $e');
  }
}

Future<Token?> getAccessToken() async {
  SecureStorage storage = SecureStorage.instance;
  String? jsonString = await storage.read('access_token');

  return jsonString != null ? Token.fromJson(json.decode(jsonString)) : null;
}

Future<RefreshToken?> getRefreshToken() async {
  SecureStorage storage = SecureStorage.instance;
  String? jsonString = await storage.read('refresh_token');

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
    SecureStorage storage = SecureStorage.instance;
    final userDetails = await storage.read('user_details');
    //print(userDetails);
    if (userDetails != null) {
      _details = UserDetails.fromJson(json.decode(userDetails));
      notifyListeners();
    }
  }

  UserDetails? get details => _details;
}
