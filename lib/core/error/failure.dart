import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const []]);

  @override
  List<Object> get props => [properties];
}

class OperationFailure extends Failure {
  final String message;
  final Object? wrapped;

  final Object? response;

  OperationFailure({
    this.message = 'Operation Failure',
    this.wrapped,
    this.response,
  }) : super([message, wrapped, response]);

  @override
  String toString() => "${wrapped != null ? 'wrapped($wrapped)->' : ''}msg($message)";
}

class ServerOperationFailure extends OperationFailure {
  ServerOperationFailure({
    message = 'Server Failure',
    wrapped,
    response,
  }) : super(message: message, wrapped: wrapped, response: response);
}

class UnknownOperationFailure extends OperationFailure {
  UnknownOperationFailure(wrapped) : super(message: 'Something went wrong', wrapped: wrapped);
}
