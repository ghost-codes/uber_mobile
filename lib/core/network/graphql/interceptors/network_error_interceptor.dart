import 'package:dio/dio.dart';
import 'package:uber_mobile/core/network/network_error.dart';

/// This listens for errors in the network
class NetworkErrorInterceptor extends InterceptorsWrapper {
  /// Initialize network listener by passing
  /// a function triggered when an error occurs
  /// during a network request
  NetworkErrorInterceptor(this.onNetworkError);

  final Function(NetworkError error) onNetworkError;

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final networkError = NetworkError.fromDio(err);
    onNetworkError(networkError);
    handler.next(err);
  }
}
