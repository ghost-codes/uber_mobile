import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:uber_mobile/core/network/apiConstants.dart';
import 'package:uber_mobile/core/network/http_response.dart';
import 'package:uber_mobile/core/network/network_error.dart';
import 'package:uber_mobile/core/services/serviceLocator.dart';
import 'package:uber_mobile/utils/appSharedPref.dart';

class HttpClient {
  final AppSharedPref _prefs = sl<AppSharedPref>();
  // late void Function() _onNetworkAuthError;

  late Dio _dio;

  HttpClient(
      // {
      // required void Function() onNetworkAuthError
      )
  // : _onNetworkAuthError = onNetworkAuthError {
  {
    BaseOptions options = BaseOptions(
      baseUrl: ApiConstants.API_URL,
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        io.HttpHeaders.acceptHeader: 'application/json',
        io.HttpHeaders.contentTypeHeader: 'application/json'
      },
      responseType: ResponseType.json,
    );
    _dio = Dio(options);

    // Setup interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions request, RequestInterceptorHandler handler) async {
          print(
              'send request：path:${request.path}，baseURL:${request.baseUrl}, data:${jsonEncode(request.data)} query:${request.queryParameters}');
          //lock the dio.
          // _dio.lock();

          String? accessToken = _prefs.accessToken;
          request.headers["Authorization"] = "Bearer $accessToken";
          // _dio.unlock();
          return handler.next(request);
        },
        onError: (DioError error, ErrorInterceptorHandler handler) async {
          // if (error.response?.statusCode == 401) {
          //   try {
          //     String? refresh_token = _prefs.refreshToken;
          //     final response = await _dio.post(ApiConstants.RefreshTokens, data: {
          //       "refreshToken": refresh_token,
          //     });

          //     await _prefs.setAccessToken(response.data["accessToken"]);
          //     handler.resolve(await _retry(error.requestOptions));
          //     return;
          //   } catch (e) {
          //     handler.next(error);
          //   }
          // }
          handler.next(error);
        },
      ),
    );
  }

  _retry(RequestOptions requestOptions) async {
    final options = Options(method: requestOptions.method, headers: requestOptions.headers);
    return await _dio.request(requestOptions.path,
        options: options,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters);
  }

  Future<HttpResponse> execute({
    String path = '',
    String method = '',
    dynamic data,
    Map<String, dynamic>? query,
    String? contentType,
  }) async {
    try {
      Response response = await _dio.request(
        path,
        data: data,
        queryParameters: query,
        options: Options(method: method, contentType: contentType),
      );
      return HttpResponse(isSuccessful: true, data: response.data);
    } on DioError catch (dioError) {
      print(dioError.error);

      String errorMessage = _errorHandler(dioError);
      throw NetworkError(errorMessage);
    }
  }

  String _errorHandler(DioError error) {
    String errorDescription = '';
    switch (error.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        errorDescription = "Error: Please check internet connectivity";
        break;
      case DioErrorType.badResponse:
        errorDescription = _dioResponseTypeResponsHandler(error);
        break;
      case DioErrorType.unknown:
        // if (error.type is SocketException) {
        errorDescription = "Error: Please check internet connectivity";
        // } else {
        // error_description = "Unexpected error occured";
        // }
        break;
      default:
        errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }

  String _dioResponseTypeResponsHandler(DioError error) {
    switch (error.response?.statusCode) {
      case 401:
        return error.response!.data["message"];
      case 404:
        return "Oops! Service not found.";
      default:
        if (error.response!.data["message"] is List) return error.response!.data["message"][0];
        if (error.response!.data["message"] != null) return error.response!.data["message"];

        return "Error Occured";
    }
  }
}
