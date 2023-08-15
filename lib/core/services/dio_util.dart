import 'package:dio/dio.dart';
import '/core/services/login.dart';
import '../../features/checkIn_app/models/token.dart';
import '/core/services/storage.dart';
import 'dart:convert';


class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers["requiresToken"] == false) {
      // if the request doesn't need token, then just continue to the next interceptor
      options.headers.remove("requiresToken"); //remove the auxiliary header
      return handler.next(options);
    }

    Token? token = await getAccessToken();
    if (token != null) {
      options.headers['Authorization'] =
          '${token.tokenType} ${token.accessToken}';
      return handler.next(options);
    }

    // add else condition where user is redirected to login
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Handle the response if needed
    handler.next(response); // Continue with the response
  }

  @override
  void onError(DioError error, ErrorInterceptorHandler handler) async {
    // Handle errors, such as expired tokens

    if (error.response?.statusCode == 401) {
      // Access token expired, try refreshing the token
      //_dio.interceptors.requestLock.lock();
      //_dio.interceptors.responseLock.lock();

      RequestOptions options = error.requestOptions;
      if (await refreshAccessToken()){
        return handler.resolve(await _retry(options));
      }
    }
    return handler.next(error);
  }

Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }


  Future<bool> refreshAccessToken() async {
    RefreshToken? token = await getRefreshToken();
    if (token != null) {
      final response = await _dio
          .post('/login/refresh-token', data: {'token': token.refreshToken});
      if(response.statusCode == 200){
        Token newAccessToken =  Token.fromJson(response.data);
        
        SecureStorage storage = SecureStorage.instance;
        await storage.store('access_token', json.encode(newAccessToken.toJson()));
        
        return true;
      } else{
        SecureStorage storage = SecureStorage.instance;
        await storage.clear();
        return false;
      }
    } else{
      return false;
    }
  } 
}