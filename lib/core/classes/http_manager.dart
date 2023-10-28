import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bbuddy_app/core/core.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle errors, such as expired tokens

    if (err.response?.statusCode == 401) {
      // Access token expired, try refreshing the token
      //_dio.interceptors.requestLock.lock();
      //_dio.interceptors.responseLock.lock();

      RequestOptions options = err.requestOptions;
      String? token = await getIdToken();
      if (token != null) {
        options.headers.addAll({'token': token});
        return handler.resolve(await _retry(options));
      }
    }
    return handler.next(err);
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
}

class Http extends HttpManager {
  Http({String? baseUrl, Map<String, dynamic>? headers})
      : super(baseUrl!, headers!);
  void addHeaders(Map<String, dynamic>? headers) {
    _dio.options.headers.addAll(headers ?? {});
  }
}

class HttpManager {
  final Dio _dio = Dio();

  HttpManager([String baseUrl = '', Map<String, dynamic>? headers]) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = headers;

    // how to solve flutter CERTIFICATE_VERIFY_FAILED error while performing a POST request?
    if (kIsWeb) {
      _dio.options.headers['Content-Type'] = '*';
      _dio.options.headers['Access-Control-Allow-Origin'] = '*';
      _dio.options.headers['Access-Control-Allow-Methods'] = '*';
    }
    if (!kIsWeb) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    _dio.interceptors.add(AuthInterceptor(_dio));
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? progress,
  }) async {
    Response? response;
    try {
      response = await _dio.get(
        url,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: progress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.post(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.put(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.patch(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
  }) async {
    Response? response;
    try {
      response = await _dio.delete(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> download(
    String url,
    dynamic savePath, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? receiveProgress,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
  }) async {
    Response? response;
    try {
      response = await _dio.download(
        url,
        savePath,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> head(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
  }) async {
    Response? response;
    try {
      response = await _dio.head(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> fetch(RequestOptions requestOptions) async {
    Response? response;
    try {
      response = await _dio.fetch(requestOptions);
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> getUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.getUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> headUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.headUri(
        uri,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> postUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.postUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> putUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.putUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> patchUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.patchUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> deleteUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.deleteUri(
        uri,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> downloadUri(Uri uri, dynamic savePath,
      {dynamic data,
      Options? options,
      CancelToken? cancelToken,
      void Function(int progress, int total)? receiveProgress,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader}) async {
    Response? response;
    try {
      response = await _dio.downloadUri(
        uri,
        savePath,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        data: data,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> request(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
    void Function(int progress, int total)? sendProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.request(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> requestUri(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
    void Function(int progress, int total)? sendProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.requestUri(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }
}
