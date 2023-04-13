import 'package:dio/dio.dart';
import 'package:uber_mobile/core/network/graphql/graphql_client.dart';

/// This calls catches all gql related
/// errors and notifies us through the
/// [onGqlError] callback
class GraphqlErrorInterceptor extends InterceptorsWrapper {
  /// constructor
  GraphqlErrorInterceptor(
    this.onGqlError, {
    required Dio retryDio,
  }) : _retryDio = retryDio;

  /// callback for graphql errors
  final Future<bool> Function(List<GraphQLError> gqlErrors) onGqlError;
  final Dio _retryDio;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final result = Map<String, dynamic>.from(response.data);
    final errorsList = result['errors'];

    if (errorsList != null) {
      final errList = (errorsList as Iterable).map((e) => GraphQLError.fromJson(e)).toList();

      final shouldRetry = await onGqlError(errList);

      if (shouldRetry) {
        var options = response.requestOptions;
        try {
          final result0 = await _retryDio.fetch(options);
          handler.next(result0);
          return;
        } catch (_) {}
      }
    }

    handler.next(response);
  }
}
