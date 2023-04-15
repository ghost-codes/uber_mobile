import 'package:dio/dio.dart';

import 'error.dart';

// Is Thrown when A Network Related Error Occurs
class NetworkError implements Exception {
  /// Constructor
  NetworkError(
    this.message, {
    Error? error,
    rawLog,
  }) {
    if (error?.fields != null) {
      fullError = error!.fields!.map((e) => '${e.field} ${e.message}').join('\n\n-').trim();
      rawResponse = error.toJson();
    }

    rawResponse = rawLog;
  }

  factory NetworkError.fromDio(DioError dioErr) {
    String? message;
    Error? errr;

    switch (dioErr.type) {
      case DioErrorType.cancel:
        message = 'Request cancelled';
        break;
      case DioErrorType.sendTimeout:
      case DioErrorType.connectionTimeout:
        message = 'Request timed out';
        break;
      case DioErrorType.receiveTimeout:
        message = 'Response timed out';
        break;
      case DioErrorType.unknown:
        if (dioErr.response == null) {
          message = dioErr.message;
          break;
        }
        final statusCode = dioErr.response!.statusCode!;
        if (statusCode >= 200 && statusCode < 400) {
          final response = dioErr.response?.data;
          if (response != null) errr = Error.fromJson(response);

          message = dioErr.message;
        } else {
          message = dioErr.message;
        }
        break;
      default:
    }

    message ??= 'An unknown error occurred';

    if (message.contains('SocketException') || message.contains('failed host lookup')) {
      message = 'Please check your internet \nsettings and try again. ';
    }

    return NetworkError(
      message,
      error: errr,
      rawLog: dioErr.response?.data,
    );
  }

  /// This holds the reason why the request failed
  /// you can display this to the user
  String message;

  /// This holds the full error, assuming there're
  /// other parts especially `Validation` errors
  String? fullError;

  /// This is the full dump of the error from the server
  /// Useful for logging purposes
  dynamic rawResponse;

  Map<String, dynamic> toJson() => {
        'message': message,
        'fullError': fullError,
        'rawResponse': rawResponse.toString(),
      };
}
