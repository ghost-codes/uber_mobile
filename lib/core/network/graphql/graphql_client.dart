import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:uber_mobile/core/graphql/GraphqlRequest.dart';
import 'package:uber_mobile/core/network/network_error.dart';

import '../error.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/graphql_error_interceptor.dart';
import 'interceptors/network_error_interceptor.dart';

abstract class GraphQLClient {
  static const String name = 'GraphQL Client';

  void setHeader(Map<String, String> header);
  Dio get dioInstance;

  Future<Map<String, dynamic>?> runMutation(GraphqlRequest request, {String? resultKey});

  Future<Map<String, dynamic>?> runQuery(GraphqlRequest request, {String? resultKey});

  /// call this to pause incoming requests
  void pauseRequests();

  /// call this to resume requests
  void resumeRequests();

  void cancelRequests();

  /// this uses the refresh token dio
  Future<Map<String, dynamic>?> refreshToken(GraphqlRequest request, {String? resultKey});

  @override
  String get moduleName => name;
}

class GraphQLClientImpl extends GraphQLClient {
  /// constructor
  GraphQLClientImpl(
    FutureOr<String?> Function() getToken, {
    Future<bool> Function(List<GraphQLError> errors)? onGraphQLError,
    Function(NetworkError error)? onNetworkError,
    required String apiEndpoint,
    this.canLogRequests = true,
    Dio? dioInstance,
    int connectTimeout = CONNECT_TIME_OUT,
    int receiveTimeout = RECEIVE_TIME_OUT,
  }) {
    final dioOptions = BaseOptions(
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      baseUrl: apiEndpoint,
    );

    _dioInstance = dioInstance ?? Dio(dioOptions);
    _refreshDioInstance = Dio(dioOptions);
    _dioInstance.interceptors.add(AuthInterceptor(getToken));

    // _refreshDioInstance.interceptors.add(
    //   // RequestLoggingInterceptor(_logger),
    // );

    if (onGraphQLError != null) {
      attachErrorInterceptor(onGraphQLError, onNetworkError: onNetworkError);
    }
  }

  @override
  Dio get dioInstance => _dioInstance;

  // AchieveLogger get _logger => AchieveCore.instance.logger;

  final bool canLogRequests;

  final Map<String, String> customHeaders = {};

  /// call this to attach the error
  /// interceptor
  ///
  /// This has been moved here so we can
  /// attach the error listener at which
  /// point we want
  void attachErrorInterceptor(
    Future<bool> Function(List<GraphQLError> errors) onGraphqlError, {
    Function(NetworkError error)? onNetworkError,
  }) {
    if (onNetworkError != null) {
      _dioInstance.interceptors.add(NetworkErrorInterceptor(onNetworkError));
    }

    _dioInstance.interceptors.add(GraphqlErrorInterceptor(
      onGraphqlError,
      retryDio: _dioInstance,
    ));
  }

  /// Requests will timeout in [30] seconds when
  /// trying to reach the server
  static const int CONNECT_TIME_OUT = 60000;

  /// Requests will timeout in [30] seconds when
  /// waiting on server for response
  static const int RECEIVE_TIME_OUT = 60000;

  late Dio _dioInstance, _refreshDioInstance;

  Future<T?> _post<T>(Map<String, dynamic> body, {Dio? dio}) async {
    dio ??= _dioInstance;
    try {
      print(body);
      final result = await dio.post('', data: body);
      return result.data;
    } on DioError catch (e) {
      throw NetworkError.fromDio(e);
    }
  }

  @override
  Future<Map<String, dynamic>?> runMutation(
    GraphqlRequest request, {
    String? resultKey,
  }) async {
    _logRequest(request, resultKey: resultKey);

    final response = await _post({
      'query': request.query,
      'variables': request.variables,
      if (request.variables != null) 'operationName': request.operationName,
    });

    return _handleResponse(response, resultKey: resultKey);
  }

  @override
  Future<Map<String, dynamic>?> runQuery(GraphqlRequest request, {String? resultKey}) async {
    _logRequest(request, resultKey: resultKey);

    var response = await _post({
      'query': request.query,
      'variables': request.variables,
      if (request.operationName != null) 'operationName': request.operationName,
    });

    return _handleResponse(response, resultKey: resultKey);
  }

  Map<String, dynamic>? _handleResponse(Map<String, dynamic>? response, {String? resultKey}) {
    if (response == null) return null;

    _logResponse(response, resultKey: resultKey);

    final errorsList = response['errors'];

    if (errorsList != null) {
      // _logger.error(response, localOnly: true);

      final errList = (errorsList as Iterable).map((e) => GraphQLError.fromJson(e)).toList();
      throw NetworkError(
        errList.first.message,
        rawLog: errorsList,
      );
    }

    response = Map<String, dynamic>.from(response['data']);
    final resultMap = (resultKey == null ? response : response[resultKey]);
    final errorMap = Map<String, dynamic>.from(resultMap)['error'];
    if (errorMap != null) {
      final error = Error.fromJson(errorMap);

      throw NetworkError(error.displayMessage ?? 'Unknown GraphQL Error', error: error);
    }

    if (resultMap == null) return null;
    return resultMap;
  }

  void _logRequest(
    GraphqlRequest request, {
    int maxQueryLines = 4,
    String? resultKey,
  }) {
    // if (!canLogRequests) return;

    final queryLines = request.query.split('\n');
    final hasMoreLines = queryLines.length > maxQueryLines;
    log({
      'query': [
        ...queryLines.sublist(0, hasMoreLines ? maxQueryLines : queryLines.length),
        if (hasMoreLines) '...and more...',
      ],
      'variables': request.variables,
      'operationName': request.operationName,
      'resultKey': resultKey,
    }.toString());
  }

  void _logResponse(
    Map<String, dynamic> response, {
    String? resultKey,
  }) {
    if (!canLogRequests) return;

    // _logger.debug({
    //   'response': response,
    //   'resultKey': resultKey,
    // });
  }

  @override
  void pauseRequests() {
    // _dioInstance.interceptors.requestLock.lock();
    // _dioInstance.interceptors.responseLock.lock();
  }

  @override
  void resumeRequests() {
    // _dioInstance.interceptors.requestLock.unlock();
    // _dioInstance.interceptors.responseLock.unlock();
  }

  @override
  Future<Map<String, dynamic>?> refreshToken(
    GraphqlRequest request, {
    String? resultKey,
  }) async {
    _logRequest(request, resultKey: resultKey);

    var response = await _post({
      'query': request.query,
      'variables': request.variables,
      if (request.operationName != null) 'operationName': request.operationName,
    }, dio: _refreshDioInstance);

    return _handleResponse(response, resultKey: resultKey);
  }

  @override
  void setHeader(Map<String, String> headers) {
    customHeaders.addAll(headers);

    setHeaders(_dioInstance, customHeaders);
    setHeaders(_refreshDioInstance, customHeaders);
  }

  /// set new headers
  void setHeaders(Dio instance, Map<String, dynamic> headers) {
    final options = instance.options.copyWith(headers: headers);
    instance.options = options;
  }

  @override
  void cancelRequests() {
    // _dioInstance.clear();
    // _refreshDioInstance.clear();
  }
}

class GraphQLError {
  const GraphQLError(this.extensions, this.message);

  factory GraphQLError.fromJson(Map<String, dynamic> data) {
    return GraphQLError(
      data['extensions'],
      data['message'],
    );
  }

  final String message;
  final Map<String, dynamic>? extensions;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
        'extensions': extensions,
      };
}
