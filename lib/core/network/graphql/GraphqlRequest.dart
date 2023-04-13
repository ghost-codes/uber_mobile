import 'package:equatable/equatable.dart';

abstract class GraphqlRequest extends Equatable {
  /// constructor
  const GraphqlRequest(
    this.query, {
    this.variables,
    this.operationName,
  });

  /// the query
  final String query;

  /// the variables
  final Map<String, dynamic>? variables;

  /// the operation name
  final String? operationName;

  @override
  String toString() {
    return '''
    Query:          $query,
    Variables:      $variables,
    OperationName:  $operationName,
    ''';
  }

  @override
  List<Object?> get props => [query, operationName];
}
